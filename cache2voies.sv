module cache #(
    localparam ByteOffsetBits = 4,
    localparam IndexBits = 6,
    localparam TagBits = 22,
    localparam NrWordsPerLine = 4,
    localparam NrLines = 64,
    localparam LineSize = 32 * NrWordsPerLine,
    localparam Ways = 2
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

    typedef struct packed {
        logic [TagBits-1:0] tag
        logic [LineSize-1:0] data
        logic valid
    } ligne_cache


    ligne_cache cache_mem [0:NrLines-1][0:Ways-1] // premiere difference, on a un tableau de 2 lignes de cache


    logic lru_bits [0:NrLines-1] // on implemente en plus un tableau de bits pour le LRU


    logic [TagBits-1:0] addr_tag
    logic [IndexBits-1:0] addr_index
    logic [ByteOffsetBits-1:0] addr_offset

    always_comb begin
        addr_tag = addr_i[31 : 32 - TagBits]
        addr_index = addr_i[32 - TagBits - 1 : ByteOffsetBits]
        addr_offset = addr_i[ByteOffsetBits-1 : 0]
    end

    logic hit_way0
    logic hit_way1
    always_comb begin // on separe le signal hit en 2 signaux
        hit_way0 = cache_mem[addr_index][0].valid && (cache_mem[addr_index][0].tag == addr_tag)
        hit_way1 = cache_mem[addr_index][1].valid && (cache_mem[addr_index][1].tag == addr_tag)
    end
  
    wire is_hit = hit_way0 || hit_way1 // on garde tout de meme un signal global is_hit

    logic hit_way
    always_comb begin
        if (hit_way0)
            hit_way = 0
        else if (hit_way1)
            hit_way = 1
        else
            hit_way = 0
    end

    logic [1:0] word_sel
    always_comb begin
        word_sel = addr_offset[3:2]
    end

    logic evict_way
    always_comb begin
        evict_way = lru_bits[addr_index] // definit la logique d'écrasement d'une ligne d'une voie
    end

    always_comb begin
        read_valid_o = 1'b0
        read_word_o = 32'b0
        mem_read_en_o = 1'b0
        mem_addr_o = 32'b0
        if (read_en_i) begin
            if (is_hit) begin
                read_valid_o = 1'b1
                read_word_o = cache_mem[addr_index][hit_way].data[word_sel*32 +: 32] /// la variable hit_way permet de selectionner la voie correspondante
            end else begin
                mem_addr_o = {addr_i[31:ByteOffsetBits], {ByteOffsetBits{1'b0}}}
                mem_read_en_o = 1'b1
            end
        end
    end

    always_ff @(posedge clk_i or negedge rstn_i) begin 
        if (!rstn_i) begin
            for (int i = 0; i < NrLines; i++) begin // on reinitialise le cache
                cache_mem[i][0].valid <= 1'b0
                cache_mem[i][1].valid <= 1'b0
                cache_mem[i][0].tag <= {TagBits{1'b0}}
                cache_mem[i][1].tag <= {TagBits{1'b0}}
                cache_mem[i][0].data <= {LineSize{1'b0}}
                cache_mem[i][1].data <= {LineSize{1'b0}}
                lru_bits[i] <= 1'b0
            end
        end else begin
            if (mem_read_valid_i) begin
                cache_mem[addr_index][evict_way].data <= mem_read_data_i // on ecrit dans le cache, evict_way permet de selectionner la voie a ecraser
                cache_mem[addr_index][evict_way].tag <= addr_tag
                cache_mem[addr_index][evict_way].valid <= 1'b1
                read_valid_o = 1'b1
                read_word_o = mem_read_data_i[word_sel*32 +: 32]
                lru_bits[addr_index] <= ~evict_way
            end
            if (is_hit) begin
                lru_bits[addr_index] <= ~hit_way  // on met a jour le LRU
            end
        end
    end

endmodule
