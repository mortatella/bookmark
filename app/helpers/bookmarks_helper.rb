module BookmarksHelper
  def user_allowed_to_edit(user, bookmark)
    allowed = false
    if(!current_user.bookmarks.index(bookmark).nil?)
      allowed = true
    else
      write_shares = current_user.shares.find_all{|s| s.write == true}
      write_shares.each do |s|
        if bookmark.lists.index(s.list)
          allowed = true
        end
      end
    end
    return allowed
  end
  
end
