plug "h-youhei/kakoune-surround" config %{
  declare-user-mode surround
  map global surround s ':surround<ret>' -docstring 'surround'
  map global surround c ':change-surround<ret>' -docstring 'change'
  map global surround d ':delete-surround<ret>' -docstring 'delete'
  map global surround t ':select-surrounding-tag<ret>' -docstring 'select tag'
  map global normal <a-s> ':enter-user-mode surround<ret>'
}
