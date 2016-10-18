class UsersController < ApplicationController
 
 
    def show
         @user = User.find(params[:id])
    end


    def index
        @users = User.all
        respond_to do |format|
            format.csv do
                send_data render_to_string, filename: "hoge.csv", type: :csv
        end
        end
    end
    
    def new
        @user = User.new
    end
    
    def create
        @user = User.new(user_params)
        if @user.save
            log_in @user
            flash[:success] = "Welcome to Blog"
            redirect_to @user
            else
            render 'new'
        end
    end
        
    def edit
        @user = User.find(params[:id])
    end
    
    def update
        @user = User.find(params[:id])
        if @user.update_attributes(user_params)
          flash[:success] = "Profile updated"
          redirect_to @user
        else
          render 'edit'
        end
    end
    
    def import
        if params[:csv_file].blank?
            redirect_to(admin_users_url, alert: 'インポートするCSVファイルを選択してください')
            else
            num = Admin::User.import(params[:csv_file])
            redirect_to(admin_users_url, notice: "#{num.to_s}件のユーザー情報を追加 / 更新しました")
        end
    end

    
    private
    
    def user_params
        params.require(:user).permit(:name, :email, :password, :password_confirmation)
    end

    def logged_in_user
      unless logged_in?
        store_location
        flash[:danger] = "Please log in."
        redirect_to login_url
      end
    end

    def correct_user
      @user = User.find(params[:id])
      redirect_to(root_url) unless current_user?(@user)
    end

end