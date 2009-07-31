/*******************************************************************************
 
 Copyright (C) 2008 Dirk Holtwick. All rights reserved.
 
 This program is free software; you can redistribute it and/or modify
 it under the terms of the GNU General Public License version 2 as 
 published by the Free Software Foundation.
 
 This program is distributed in the hope that it will be useful,
 but WITHOUT ANY WARRANTY; without even the implied warranty of
 MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 GNU General Public License version 2 for more details.
 
 You should have received a copy of the GNU General Public License
 along with this program; if not, write to the Free Software
 Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA  02110-1301, USA
 
 See also http://www.fsf.org/licensing/licenses/info/GPLv2.html
 
*******************************************************************************/

/* 
 * Comment out APP_OFFLINE if you want to start directly with an online page.
 * APP_FOLDER defines the folder in the projects resources that contains the
 * index.html starting page for the offline app. APP_URL is only used if APP_OFFLINE
 * is commented out.
 */

#define APP_NAME		@"crowdnews"
#define APP_OFFLINE     0
#define APP_FOLDER      @"Web"
#define APP_URL         @"https://gist.github.com/dbf8f0433e0b34c5cfb9.txt"