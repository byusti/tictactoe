import gleam/int
import gleam/io

pub fn main() {
  let game = new_game()

  io.println("Let's play a game of tic-tac-toe!")

  let assert Ok(game) = make_move(game, Five)
  let assert Ok(game) = make_move(game, One)
  let assert Ok(game) = make_move(game, Four)
  let assert Ok(game) = make_move(game, Three)
  let assert Ok(game) = make_move(game, Seven)
  let assert Ok(game) = make_move(game, Eight)
  let assert Ok(game) = make_move(game, Two)
  let assert Ok(game) = make_move(game, Six)
  let assert Ok(game) = make_move(game, Nine)
  let assert Ok(game) = make_move(game, Nine)
  case game.game_state {
    InProgress -> io.println("in progress")
    XWins -> io.println("X wins!")
    OWins -> io.println("O wins!")
    Draw -> io.println("It's a draw!")
  }
}

pub type Game {
  Game(board: Board, game_state: GameState)
}

pub type Board {
  Board(x_board: Int, o_board: Int, turn: Int)
}

pub fn new_game() -> Game {
  Game(board: new_board(), game_state: InProgress)
}

pub fn new_board() -> Board {
  Board(0b000000000, 0b000000000, 0)
}

pub fn make_move(game: Game, index: Index) -> Result(Game, String) {
  case game.game_state {
    InProgress -> {
      case make_move_inner(game.board, index) {
        Ok(new_board) -> {
          let new_game_state = determine_game_state(new_board)
          Ok(Game(board: new_board, game_state: new_game_state))
        }
        Error(e) -> Error(e)
      }
    }
    _ -> Error("game is over")
  }
}

pub fn make_move_inner(board: Board, index: Index) -> Result(Board, String) {
  let index_as_bitboard = index_to_bitboard(index)
  let occupied_bitboard = int.bitwise_or(board.x_board, board.o_board)
  let result_bitboard = int.bitwise_and(index_as_bitboard, occupied_bitboard)
  case int.is_even(board.turn) {
    True -> {
      case result_bitboard {
        0b000000000 -> {
          let new_x_board = int.bitwise_or(index_as_bitboard, board.x_board)
          let new_board =
            Board(
              x_board: new_x_board,
              o_board: board.o_board,
              turn: board.turn + 1,
            )
          Ok(new_board)
        }
        _ -> Error("space is already occupied")
      }
    }
    False -> {
      case result_bitboard {
        0b000000000 -> {
          let new_o_board = int.bitwise_or(index_as_bitboard, board.o_board)
          let new_board =
            Board(
              x_board: board.x_board,
              o_board: new_o_board,
              turn: board.turn + 1,
            )
          Ok(new_board)
        }
        _ -> Error("space is already occupied")
      }
    }
  }
}

pub fn index_to_bitboard(index: Index) -> Int {
  case index {
    One -> {
      0b100000000
    }
    Two -> {
      0b010000000
    }
    Three -> {
      0b001000000
    }
    Four -> {
      0b000100000
    }
    Five -> {
      0b000010000
    }
    Six -> {
      0b000001000
    }
    Seven -> {
      0b000000100
    }
    Eight -> {
      0b000000010
    }
    Nine -> {
      0b000000001
    }
  }
}

pub fn determine_game_state(board: Board) -> GameState {
  let win_cond_1_test_x =
    int.bitwise_and(win_cond_1, board.x_board) == win_cond_1
  let win_cond_2_test_x =
    int.bitwise_and(win_cond_2, board.x_board) == win_cond_2
  let win_cond_3_test_x =
    int.bitwise_and(win_cond_3, board.x_board) == win_cond_3
  let win_cond_4_test_x =
    int.bitwise_and(win_cond_4, board.x_board) == win_cond_4
  let win_cond_5_test_x =
    int.bitwise_and(win_cond_5, board.x_board) == win_cond_5
  let win_cond_6_test_x =
    int.bitwise_and(win_cond_6, board.x_board) == win_cond_6
  let win_cond_7_test_x =
    int.bitwise_and(win_cond_7, board.x_board) == win_cond_7
  let win_cond_8_test_x =
    int.bitwise_and(win_cond_8, board.x_board) == win_cond_8
  let is_x_winner =
    win_cond_1_test_x
    || win_cond_2_test_x
    || win_cond_3_test_x
    || win_cond_4_test_x
    || win_cond_5_test_x
    || win_cond_6_test_x
    || win_cond_7_test_x
    || win_cond_8_test_x
  case is_x_winner {
    True -> XWins
    False -> {
      let win_cond_1_test_o =
        int.bitwise_and(win_cond_1, board.o_board) == win_cond_1
      let win_cond_2_test_o =
        int.bitwise_and(win_cond_2, board.o_board) == win_cond_2
      let win_cond_3_test_o =
        int.bitwise_and(win_cond_3, board.o_board) == win_cond_3
      let win_cond_4_test_o =
        int.bitwise_and(win_cond_4, board.o_board) == win_cond_4
      let win_cond_5_test_o =
        int.bitwise_and(win_cond_5, board.o_board) == win_cond_5
      let win_cond_6_test_o =
        int.bitwise_and(win_cond_6, board.o_board) == win_cond_6
      let win_cond_7_test_o =
        int.bitwise_and(win_cond_7, board.o_board) == win_cond_7
      let win_cond_8_test_o =
        int.bitwise_and(win_cond_8, board.o_board) == win_cond_8
      let is_o_winner =
        win_cond_1_test_o
        || win_cond_2_test_o
        || win_cond_3_test_o
        || win_cond_4_test_o
        || win_cond_5_test_o
        || win_cond_6_test_o
        || win_cond_7_test_o
        || win_cond_8_test_o
      case is_o_winner {
        True -> OWins
        False -> {
          let is_draw = board.turn == 9
          case is_draw {
            True -> Draw
            False -> InProgress
          }
        }
      }
    }
  }
}

const win_cond_1 = 0b100010001

const win_cond_2 = 0b001010100

const win_cond_3 = 0b111000000

const win_cond_4 = 0b000111000

const win_cond_5 = 0b000000111

const win_cond_6 = 0b100100100

const win_cond_7 = 0b010010010

const win_cond_8 = 0b001001001

pub type GameState {
  InProgress
  XWins
  OWins
  Draw
}

pub type Index {
  One
  Two
  Three
  Four
  Five
  Six
  Seven
  Eight
  Nine
}
