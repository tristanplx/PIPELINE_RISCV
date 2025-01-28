module cache #(
    // Q1  localparam
    localparam ByteOffsetBits = 4,
    localparam IndexBits = 6,
    localparam TagBits = 22,
    localparam NrWordsPerLine = 4,
    localparam NrLines = 64,
    localparam LineSize = 32 * NrWordsPerLine
)(
    input logic clk_i,
    input logic rstn_i,
    input logic [31:0] addr_i,
    input logic read_en_i,
    output logic read_valid_o,
    output logic [31:0] read_word_o,
    output logic [31:0] mem_addr_o,
    output logic mem_read_en_o,
    input logic mem_read_valid_i,
    input logic [LineSize-1:0] mem_read_data_i
);

    // Q2  On definit une structure contenant l'instruction, mais aussi ses metadonnees
    typedef struct packed {
        logic [TagBits-1:0] tag //metadonnee
        logic [LineSize-1:0] data //ligne de cache, 4 mots stockés
        logic valid //metadonnee
    } ligne_cache

    // Q3 :On declare un tableau avec la structure definit ci dessus pour ocnstruire notre cache
    ligne_cache cache_mem [0:NrLines-1]

    // Q4 : Découpage de l'adresse  | 31 . Tag . 10 | 9 . Index . 4 | 3 . Offset . 0 |

    logic [TagBits-1:0] addr_tag
    logic [IndexBits-1:0] addr_index
    logic [ByteOffsetBits-1:0] addr_offset

    always_comb begin
        addr_tag = addr_i[31 : 32 - TagBits]
        addr_index = addr_i[32 - TagBits - 1 : ByteOffsetBits]
        addr_offset = addr_i[ByteOffsetBits-1 : 0]
    end

    // Q5 : Hit ou miss -> hit si la ligne est valide et que le tag correspond, miss sinon
    logic is_hit
    logic [1:0] word_sel

    always_comb begin
        word_sel = addr_offset[3:2]
        is_hit = cache_mem[addr_index].valid && (cache_mem[addr_index].tag == addr_tag) // hit si correspondace tag et ligne valide
    end

    // Q6 & Q7 : Sorties
    always_comb begin
        read_valid_o = 1'b0
        read_word_o = 32'b0
        mem_read_en_o = 1'b0
        mem_addr_o = 32'b0
        if (read_en_i) begin
            if (is_hit) begin // si hit on renvoie la donnée
                read_valid_o = 1'b1 // on peut lire la donnee ( signal utilise dans le datapath)
                read_word_o = cache_mem[addr_index].data[word_sel*32 +: 32]
            end else begin
                mem_addr_o = {addr_i[31:ByteOffsetBits], {ByteOffsetBits{1'b0}}} // si miss on demande la donnee a la memoire
                mem_read_en_o = 1'b1
            end
        end
    end

    // Q8, Q9, Q10 ecriture dans le cache
    always_ff @(posedge clk_i or negedge rstn_i) begin // on ecrit dans le cache si on a une donnee valide
        if (!rstn_i) begin
            for (int i = 0; i < NrLines; i++) begin
                cache_mem[i].valid <= 1'b0
            end
        end else begin
            if (mem_read_valid_i) begin
                cache_mem[addr_index].data <= mem_read_data_i // on ecrit la donnee dans le cache
                cache_mem[addr_index].tag <= addr_tag // on met a jour le tag
                cache_mem[addr_index].valid <= 1'b1 // on met a jour la validite
                read_valid_o = 1'b1 // on debloque la lecture
                read_word_o = mem_read_data_i[word_sel*32 +: 32] // on renvoie la donnee
            end
        end
    end

endmodule
