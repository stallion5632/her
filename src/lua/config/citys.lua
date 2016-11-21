local citys = {

['北京']={'东城区','西城区','崇文区','宣武区','朝阳区','丰台区','石景山区','海淀区','门头沟区','房山区','通州区','顺义区','昌平区','大兴区','怀柔区','平谷区','密云县','延庆县'},

['上海']= {'黄浦区','卢湾区','徐汇区','长宁区','静安区','普陀区','闸北区','虹口区','杨浦区','闵行区','嘉定区','浦东新区','宝山区','金山区','松江区','青浦区','南汇区','奉贤区','崇明县'},

['天津']={'和平区','河东区','河西区','南开区','河北区','红桥区','塘沽区','汉沽区','大港区','东丽区','西青区','津南区','北辰区','武清区','宝坻区','蓟县','宁河县','静海县'},

['重庆']={'渝中区','万州区','大渡口区','江北区','沙坪坝区','九龙坡区','南岸区','北碚区','万盛区','双桥区','渝北区','巴南区','涪陵区','黔江区','长寿区','江津市','合川市','南川市','綦江县','潼南县','铜梁县','大足县','壁山县','垫江县','荣昌县','武隆县','丰都县','城口县','梁平县','开县','巫溪县','巫山县','奉节县','云阳县','忠县','酉阳县','石柱县','秀山县','彭水县'},

['山东'] = {'济南','青岛','聊城','德州','东营','淄博','潍坊','烟台','威海','日照','临沂','枣庄','济宁','泰安','莱芜','滨州','菏泽','章丘','胶州','胶南','即墨','平度','莱西','临清','乐陵','禹城','安丘','昌邑','高密','青州','诸城','寿光','栖霞','海阳','龙口','莱阳','莱州','蓬莱','招远','文登','荣成','乳山','滕州','曲阜','兖州','邹城','新泰','肥城'} ,

['江苏'] = {'南京','徐州','连云港','宿迁','淮安','盐城','扬州','泰州','南通','镇江','常州','无锡','苏州','江阴','宜兴','邳州','新沂','金坛','溧阳','常熟','张家港','太仓','昆山','吴江','如皋','通州','海门','启东','大丰','东台','高邮','仪征','江都','扬中','句容','丹阳','兴化','姜堰','泰兴','靖江'},

['安徽'] = {'合肥','宿州','淮北','阜阳','蚌埠','淮南','滁州','马鞍山','芜湖','铜陵','安庆','黄山','六安','巢湖','池州','宣城','亳州'},

['浙江'] = {'杭州','宁波','湖州','嘉兴','舟山','绍兴','衢州','金华','台州','温州','丽水','临安','富阳','建德','慈溪','余姚','奉化','平湖','海宁','桐乡','诸暨','上虞','嵊州','江山','兰溪','永康','义乌','东阳','临海','温岭','瑞安','乐清','龙泉'} ,

['福建'] = {'厦门','福州','南平','三明','莆田','泉州','漳州','龙岩','宁德','福清','长乐','邵武','武夷山','建瓯','建阳','永安','石狮','晋江','南安','龙海','漳平','福安','福鼎'},

['河北'] = {'石家庄','邯郸','唐山','保定','秦皇岛','邢台','张家口','承德','沧州','廊坊','衡水','辛集','藁城','晋州','新乐','鹿泉','丰南','遵化','迁安','霸州','三河','定州','涿州','安国','高碑店','泊头','任丘','黄骅','河间','冀州','深州','南宫','沙河','武安'} ,

['山西'] = {'太原','大同','朔州','阳泉','长治','晋城','忻州','吕梁','晋中','临汾','运城','古交','潞城','高平','原平','孝义','汾阳','介休','侯马','霍州','永济','河津'} ,

['内蒙古'] = {'呼和浩特','包头','乌海','赤峰','呼伦贝尔','通辽','乌兰察布','鄂尔多斯','巴彦淖尔','满洲里','扎兰屯','牙克石','根河','额尔古纳','乌兰浩特','阿尔山','霍林郭勒','锡林浩特','二连浩特','丰镇'} ,

['广东'] = {'广州','深圳','清远','韶关','河源','梅州','潮州','汕头','揭阳','汕尾','惠州','东莞','珠海','中山','江门','佛山','肇庆','云浮','阳江','茂名','湛江','从化','增城','英德','连州','乐昌','南雄','兴宁','普宁','陆丰','恩平','台山','开平','鹤山','高要','四会','罗定','阳春','化州','信宜','高州','吴川','廉江','雷州'} ,

['广西'] = {'南宁','桂林','柳州','梧州','贵港','玉林','钦州','北海','防城港','崇左','百色','河池','来宾','贺州','岑溪','桂平','北流','东兴','凭祥','宜州','合山'} ,

['海南'] = {'海口','三亚','琼海市','文昌市','万宁市','东方市','儋州市','五指山市'},

['湖北'] = {'武汉','十堰','襄樊','荆门','孝感','黄冈','鄂州','黄石','咸宁','荆州','宜昌','随州','仙桃','天门','潜江','丹江口','老河口','枣阳','宜城','钟祥','汉川','应城','安陆','广水','麻城','武穴','大冶','赤壁','石首','洪湖','松滋','宜都','枝江','当阳','恩施','利川'},

['湖南'] = {'长沙','张家界','常德','益阳','岳阳','株洲','湘潭','衡阳','郴州','永州','邵阳','怀化','娄底','浏阳','津市','沅江','汨罗','临湘','醴陵','湘乡','韶山','耒阳','常宁','资兴','武冈','洪江','冷水江','涟源','吉首'} ,

['河南'] = {'郑州','开封','洛阳','平顶山','安阳','鹤壁','新乡','焦作','濮阳','许昌','漯河','三门峡','南阳','商丘','周口','驻马店','信阳','济源','荥阳','新郑','登封','新密','巩义','邓州','偃师','孟州','沁阳','卫辉','辉县','林州','永城','禹州','长葛','舞钢','汝州','义马','灵宝','项城'} ,

['江西'] = {'南昌','九江','景德镇','鹰潭','新余','萍乡','赣州','上饶','抚州','宜春','吉安','瑞昌','乐平','瑞金','南康','德兴','丰城','樟树','高安','井冈山','贵溪'}, 

['宁夏'] = {'银川','石嘴山','吴忠','中卫','固原','灵武','青铜峡'} ,

['新疆'] = {'乌鲁木齐','克拉玛依','石河子','阿拉尔','图木舒克','五家渠','喀什','阿克苏','和田','吐鲁番','哈密','阿图什','博乐','昌吉','阜康','米泉','库尔勒','伊宁','奎屯','塔城','乌苏','阿勒泰'} ,

['青海'] = {'西宁','格尔木','德令哈'} ,

['陕西'] = {'西安','延安','铜川','渭南','咸阳','宝鸡','汉中','榆林','商洛','安康','韩城','华阴','兴平'},

['甘肃'] = {'兰州','嘉峪关','金昌','白银','天水','酒泉','张掖','武威','庆阳','平凉','定西','陇南','玉门','敦煌','临夏','合作'} ,

['四川'] = {'成都','广元','绵阳','德阳','南充','广安','遂宁','内江','乐山','自贡','泸州','宜宾','攀枝花','巴中','达州','资阳','眉山','雅安','崇州','邛崃','都江堰','彭州','江油','什邡','广汉','绵竹','阆中','华蓥','峨眉山','万源','简阳','西昌'},

['云南'] = {'昆明','曲靖','玉溪','丽江','昭通','思茅','临沧','保山','安宁','宣威','潞西','瑞丽','大理','楚雄','个旧','开远','景洪'} ,

['贵州'] = {'贵阳','六盘水','遵义','安顺','清镇','赤水','仁怀','凯里','都匀','兴义','毕节','铜仁','福泉'},

['西藏'] = {'拉萨','日喀则'} ,

['辽宁'] = {'沈阳','大连','朝阳','阜新','铁岭','抚顺','本溪','辽阳','鞍山','丹东','营口','盘锦','锦州','葫芦岛','新民','瓦房店','普兰店','庄河','北票','凌源','调兵山','开原','灯塔','海城','凤城','东港','大石桥','盖州','凌海','北宁','兴城'},

['吉林'] = {'长春','吉林市','白城','松原','四平','辽源','通化','白山','德惠','九台','榆树','磐石','蛟河','桦甸','舒兰','洮南','大安','双辽','公主岭','梅河口','集安','临江','延吉','图们','敦化','珲春','龙井','和龙'} ,

['黑龙江'] = {'哈尔滨','齐齐哈尔','黑河','大庆','伊春','鹤岗','佳木斯','双鸭山','七台河','鸡西','牡丹江','绥化','双城','尚志','五常','阿城','讷河','北安','五大连池','铁力','同江','富锦','虎林','密山','绥芬河','海林','宁安','安达','肇东','海伦'},

['台湾'] = {'台北','基隆','新北','桃园县','新竹','台中','嘉义','台南','高雄','台中','离岛'},

['香港'] = {'中西区','湾仔区','东区','南区','油尖旺区','深水埗区','九龙城区','黄大仙区','观塘区','北区','大埔区','沙田区','西贡区','荃湾区','屯门区','元朗区','葵青区','离岛区'},

['澳门'] = {'花地玛堂区','圣安多尼堂区','大堂区','望德堂区','风顺堂区','嘉模堂区','圣方济各堂区','路氹城'},

}

return citys