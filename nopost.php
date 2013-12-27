<?php
/*
Plugin Name: Remove Pages and Post
Description: All the Fun Stuff ^_^
Version: 1.0
Author: TK
*/

function remove_menu_items($posts){
  
  
  remove_submenu_page('posts.php', 'edit-posts');
  
}
add_action( 'admin_menu', 'remove_posts' );