class BoardsController < ApplicationController
	def index
		@q = Board.ransack(params[:q])
		@recent_boards =  @q.result(distinct: true).paginate(page: params[:page], per_page: 30)

	end

 def new
 	@board = Board.new
 	@recent_boards = Board.order(created_at: :desc).limit(10)
 end

  def create
    @board = Board.new(board_params)

    if @board.save
      redirect_to @board
    else
      render :new
    end
  end

  def show
    @board = Board.find(params[:id])
    @minesweeper_board = @board.generate_board
  end

  private

  def board_params
    params.require(:board).permit(:email, :width, :height, :mines, :name)
  end
end
