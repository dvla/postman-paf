# PostmanPAF

Converts Royal Mail PAF (Postcode Address File) addresses to a printable format for an envelope or address label.

This is an unofficial gem to apply Royal Mail Rules & Exceptions when converting PAF addresses. 
Based on the [Royal Mail Programmers' Guide](https://www.poweredbypaf.com/wp-content/uploads/2017/07/Latest-Programmers_guide_Edition-7-Version-6.pdf), 'Formatting a PAF address for printing' (page 27).

Conversions aim to resemble addresses returned by [Royal Mail Find a PostCode](https://www.royalmail.com/find-a-postcode) as accurately as possible.

---
## Installation

Add this line to your application's Gemfile:

```ruby
gem 'postman_paf'
```

And then execute:

    $ bundle install

Or install it yourself as:

    $ gem install postman_paf

--- 
## Usage

Add PostmanPAF into a project:

```ruby
include PostmanPAF
```

### Convert method

Converting this simple address:

```ruby
PostmanPAF.convert({
                     buildingName: "1A",
                     thoroughfareName: "EXAMPLE ROAD",
                     postTown: "EXAMPLE TOWN",
                     postcode: "SA99 1BN",
                     dps: "1A",
                     language: "EN",
                     country: "WALES" 
                   })
```

Returns:
```ruby
{"line1"=>"1A EXAMPLE ROAD", "line5"=>"EXAMPLE TOWN", "postcode"=>"SA99 1BN", "country"=>"WALES", "language"=>"EN", "dps"=>"1A"}
```

Converting this more complex address:
```ruby
PostmanPAF.convert({
                     subBuildingName: "1 EXAMPLE HOUSE 2A",
                     buildingName: "EXAMPLE PLACE 3-4",
                     thoroughfareName: "EXAMPLE ROAD",
                     postTown: "EXAMPLE TOWN",
                     postcode: "SA99 1BN",
                     dps: "1A",
                     language: "EN",
                     country: "WALES" 
                   })
```

Returns:
```ruby
{"line1"=>"1 EXAMPLE HOUSE 2A EXAMPLE PLACE", "line2"=>"3-4 EXAMPLE ROAD", "line5"=>"EXAMPLE TOWN", "postcode"=>"SA99 1BN", "country"=>"WALES", "language"=>"EN", "dps"=>"1A"}
```

PostmanPAF can convert a single PAF address as a Hash, or multiple PAF addresses as an Array of Hashes.

PAF address Hashes must include `postTown` and `postcode` keys as a minimum requirement. 

#### Optional Arguments

To limit lines 1-5 of a printable address to a maximum number of characters, use the optional argument `max_line_length`. Note that this **will** cause data to be 'cut off' in places, e.g. 'TOWN' in postTown below:

```ruby
PostmanPAF.convert({
                     buildingName: "1A",
                     thoroughfareName: "EXAMPLE ROAD",
                     postTown: "EXAMPLE TOWN",
                     postcode: "SA99 1BN",
                     dps: "1A",
                     language: "EN",
                     country: "WALES" }, max_line_length: 10)
```
Returns:
```ruby
{"line1"=>"1A EXAMPLE", "line5"=>"EXAMPLE TO", "postcode"=>"SA99 1BN", "country"=>"WALES", "language"=>"EN", "dps"=>"1A"}
```

If you want to view the  Rule & Exception(s) applied to the address during format conversion, set the optional argument `logging` to `true`. This:

```ruby
PostmanPAF.convert({
                     buildingName: "1A",
                     thoroughfareName: "EXAMPLE ROAD",
                     postTown: "EXAMPLE TOWN",
                     postcode: "SA99 1BN",
                     dps: "1A",
                     language: "EN",
                     country: "WALES" }, logging: true)
```

Returns the converted address format along with a log to `STDOUT`:

```shell
[2023-12-25 11:11:11 +0000  INFO  PostmanPAF] -- ["1A EXAMPLE ROAD", "EXAMPLE TOWN"] | rule3 | exception_ii | SA99 1BN
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and the created tag, and push the `.gem` file to [rubygems.org](https://rubygems.org).

---

Special thanks to Alexander O'Mahoney, Christopher Thomas and Deepak Thankachan.

                                          .,,,.                                             
                                     ,@#.        /@*                                        
                                   &*               %/                                      
                                %#                   .@                                     
                            /@/                       ,#                                    
                       (@%.         ./%%%(,            &                                    
                   /@(          (@*    /./. ,@        */                                    
                 @/           @,     ..    ,(  @      &                                     
               %(           %.          #*&     &    &                                      
              (/           &                     @ .*                                       
              @           %        ,&@@@&   *&@@@@@.                                        
              @          &      /@@@@@@@@@&%.,/(@@@@@@@.                                    
              #*         / #    *@,(%@@@#/     ./#.  *(                                     
               (#      /         (.  #            %  %                                      
                 (@*   .,      (#             .*  # (/                                      
                      .,  .    ,,     % &     *  *, ,,                                      
                       /  *./%,.     .@&(,  . &@,%&,  &.                                    
                       (  ( %#..%%  @ &@&  @ @./%(   &                                    
                       #  # /      &        @          /(                                   
                        %  %       *.      .(             %                                 
                          % %/      ,&.  .&               ,/                                
                          # .(                            (.                                
                          ,( %              .///*,.    *&/                                  
                            .&/                    &                                        
                              &                    (,                                       
                              /,       %.       #   %                                       
                               &         //   #(    &                                       
                               #                    /.                                      
                                #                    /                                      
                @*@*&.          %                    (                                      
               %  *  .%         %%                  .%                                      
             #@,   #  *,       @ &&                 & .(                                    
            *  (.  #   %     /&( *.,&              &.&  ,@#.                                
           %   **  #   & (#   #,  &   #%.       /&   %    ,/ (((                            
           #   &   (   #,     //   #       .,@@@&,   / .%#(.    .(                          
          ,   .%  /@%, .(*@   .@    &       ,@@@@@.#.@  (#,       %.                        
          #   #(.            ,#   #  %&.    @.@@@%   (     %   (    &                       
          *                .@    #,   ,&      #@@@@( &    /#    (    &.                     
        .&.        (      *%      #*    *%   .@@@@@@@     @           //                    
        & %         ,    .&         (*     &*&@@@@@@,   .@             ,%                   
       (.  %        (   ,%&.           *#     #@@@@,   %*                @                  
       &    //     *  *@   @               .#/   .%  *.          .        @                 
       &       ,/*         &                       (             #   .     &                
       &                 .@,                       %             %  ,#.#   (.               
       /(               &. ,                       *.            %         /,               
        .@*           .@   ,                   ( %  (            %#        &.               
            &*      /@.   ..                   &,@  @         *    *      *# 