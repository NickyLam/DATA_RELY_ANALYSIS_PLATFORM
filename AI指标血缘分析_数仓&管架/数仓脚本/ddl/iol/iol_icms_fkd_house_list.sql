/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol icms_fkd_house_list
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.icms_fkd_house_list
whenever sqlerror continue none;
drop table ${iol_schema}.icms_fkd_house_list purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.icms_fkd_house_list(
    serialno varchar2(64) -- 主键
    ,areaname varchar2(200) -- 区域名称
    ,buildingcode varchar2(120) -- 楼号
    ,cusnamehire varchar2(200) -- 承租人
    ,startdatehire varchar2(20) -- 租赁起始日期
    ,obligee varchar2(40) -- 上手权利人
    ,spareroomisclearinghouse varchar2(20) -- 备用房是否清房
    ,titlecertificategettime date -- 土地使用权起始日期
    ,cityareacode varchar2(40) -- 城市编码
    ,spareroomcount varchar2(10) -- 备用房数量
    ,obligeeind varchar2(2) -- 主借人权利人标志
    ,housetype varchar2(60) -- 房屋结构类型
    ,certcodehire varchar2(64) -- 承租人证件号码
    ,assessmenttype varchar2(12) -- 评估方式
    ,formalprice number(24,2) -- 正式评估价值
    ,hsobligeerelative varchar2(200) -- 产权共有人关系
    ,hsovergroundarea number(17,2) -- 地上面积
    ,housestatus varchar2(40) -- 房屋状态
    ,projectname varchar2(1000) -- 楼盘地址（小区名称）
    ,islease varchar2(20) -- 是否出租
    ,gettime varchar2(20) -- 产权证书取得时间
    ,mortgageamt number(17,2) -- 上手抵押金额
    ,roomsize number(24,2) -- 房屋面积
    ,leasetime date -- 出租时间
    ,hsisbasement varchar2(6) -- 有无地下室
    ,housepurpose varchar2(40) -- 房屋用途
    ,remark varchar2(1000) -- 备注
    ,enddatehire varchar2(20) -- 租赁终止日期
    ,coownership varchar2(400) -- 共有情况
    ,migtflag varchar2(160) -- 迁移标志：crsrcrilcupl
    ,hsbasementarea number(17,2) -- 地下面积
    ,bkprice number(24,2) -- 贝壳网房产评估价值
    ,cityname varchar2(200) -- 城市名称
    ,lineprice number(24,2) -- 线上评估价值
    ,hsupperinmortgagedate date -- 入抵日期
    ,hsupperoutmortgagedate date -- 解抵日期
    ,certtypehire varchar2(4) -- 承租人证件类型
    ,relativeserialno varchar2(64) -- 业务流水号
    ,areacode varchar2(40) -- 区域编码
    ,projectid varchar2(100) -- 楼盘编号
    ,isvacant varchar2(20) -- 是否空置
    ,getmode varchar2(20) -- 取得方式
    ,propertyrightduedate varchar2(20) -- 土地使用权到期日期
    ,hsdecoratestate varchar2(20) -- 房产装修情况
    ,pledgeind varchar2(2) -- 是否本次抵押
    ,hscoveredarea number(17,2) -- 建筑面积
    ,mourent number(17,2) -- 月租金
    ,frontcode varchar2(20) -- 朝向
    ,rentcycle number(17,2) -- 租金收缴周期
    ,propertytype varchar2(40) -- 房产类型
    ,floorno varchar2(40) -- 楼层
    ,roomno varchar2(60) -- 单元室
    ,buildingdate varchar2(20) -- 建成年份
    ,isclearinghouse varchar2(20) -- 是否清房
    ,landcategory varchar2(40) -- 土地性质
    ,spareroomaddr varchar2(1000) -- 备用房地址
    ,gurtrate number(22,4) -- 担保率
    ,projectaddr varchar2(1000) -- 楼盘位置
    ,assessmentcom varchar2(200) -- 评估公司名称
    ,partnerobligeeind varchar2(2) -- 配偶权利人标志
    ,totalfloor varchar2(20) -- 总楼层
    ,isevlbld varchar2(2) -- 是否电梯楼
    ,contmode varchar2(64) -- 房产所属人联系方式
    ,custname varchar2(400) -- 房产所属人姓名
    ,propertydueyear varchar2(10) -- 土地使用年限
    ,valuationkh number(24,6) -- 客户录入评估总价
    ,iscompleted varchar2(2) -- 
    ,yearlyrental number(24,6) -- 
    ,houseid varchar2(10) -- 
    ,valuationdzy number(24,6) -- 
    ,address varchar2(1000) -- 
    ,reltype varchar2(10) -- 
    ,start_dt date -- 开始时间
    ,end_dt date -- 结束时间
    ,id_mark varchar2(10) -- 增删标志
    ,etl_timestamp timestamp -- ETL处理时间戳
)
partition by list(end_dt)(
     partition p_19000101 values (to_date('19000101','yyyymmdd')),
     partition p_20991231 values (to_date('20991231','yyyymmdd'))
)
storage (initial 1024k next 1024k)
compress ${option_switch} for query high
nologging
;

-- grant
grant select on ${iol_schema}.icms_fkd_house_list to ${iml_schema};
grant select on ${iol_schema}.icms_fkd_house_list to ${icl_schema};
grant select on ${iol_schema}.icms_fkd_house_list to ${idl_schema};
grant select on ${iol_schema}.icms_fkd_house_list to ${iel_schema};

-- comment
comment on table ${iol_schema}.icms_fkd_house_list is '房快贷房产列表';
comment on column ${iol_schema}.icms_fkd_house_list.serialno is '主键';
comment on column ${iol_schema}.icms_fkd_house_list.areaname is '区域名称';
comment on column ${iol_schema}.icms_fkd_house_list.buildingcode is '楼号';
comment on column ${iol_schema}.icms_fkd_house_list.cusnamehire is '承租人';
comment on column ${iol_schema}.icms_fkd_house_list.startdatehire is '租赁起始日期';
comment on column ${iol_schema}.icms_fkd_house_list.obligee is '上手权利人';
comment on column ${iol_schema}.icms_fkd_house_list.spareroomisclearinghouse is '备用房是否清房';
comment on column ${iol_schema}.icms_fkd_house_list.titlecertificategettime is '土地使用权起始日期';
comment on column ${iol_schema}.icms_fkd_house_list.cityareacode is '城市编码';
comment on column ${iol_schema}.icms_fkd_house_list.spareroomcount is '备用房数量';
comment on column ${iol_schema}.icms_fkd_house_list.obligeeind is '主借人权利人标志';
comment on column ${iol_schema}.icms_fkd_house_list.housetype is '房屋结构类型';
comment on column ${iol_schema}.icms_fkd_house_list.certcodehire is '承租人证件号码';
comment on column ${iol_schema}.icms_fkd_house_list.assessmenttype is '评估方式';
comment on column ${iol_schema}.icms_fkd_house_list.formalprice is '正式评估价值';
comment on column ${iol_schema}.icms_fkd_house_list.hsobligeerelative is '产权共有人关系';
comment on column ${iol_schema}.icms_fkd_house_list.hsovergroundarea is '地上面积';
comment on column ${iol_schema}.icms_fkd_house_list.housestatus is '房屋状态';
comment on column ${iol_schema}.icms_fkd_house_list.projectname is '楼盘地址（小区名称）';
comment on column ${iol_schema}.icms_fkd_house_list.islease is '是否出租';
comment on column ${iol_schema}.icms_fkd_house_list.gettime is '产权证书取得时间';
comment on column ${iol_schema}.icms_fkd_house_list.mortgageamt is '上手抵押金额';
comment on column ${iol_schema}.icms_fkd_house_list.roomsize is '房屋面积';
comment on column ${iol_schema}.icms_fkd_house_list.leasetime is '出租时间';
comment on column ${iol_schema}.icms_fkd_house_list.hsisbasement is '有无地下室';
comment on column ${iol_schema}.icms_fkd_house_list.housepurpose is '房屋用途';
comment on column ${iol_schema}.icms_fkd_house_list.remark is '备注';
comment on column ${iol_schema}.icms_fkd_house_list.enddatehire is '租赁终止日期';
comment on column ${iol_schema}.icms_fkd_house_list.coownership is '共有情况';
comment on column ${iol_schema}.icms_fkd_house_list.migtflag is '迁移标志：crsrcrilcupl';
comment on column ${iol_schema}.icms_fkd_house_list.hsbasementarea is '地下面积';
comment on column ${iol_schema}.icms_fkd_house_list.bkprice is '贝壳网房产评估价值';
comment on column ${iol_schema}.icms_fkd_house_list.cityname is '城市名称';
comment on column ${iol_schema}.icms_fkd_house_list.lineprice is '线上评估价值';
comment on column ${iol_schema}.icms_fkd_house_list.hsupperinmortgagedate is '入抵日期';
comment on column ${iol_schema}.icms_fkd_house_list.hsupperoutmortgagedate is '解抵日期';
comment on column ${iol_schema}.icms_fkd_house_list.certtypehire is '承租人证件类型';
comment on column ${iol_schema}.icms_fkd_house_list.relativeserialno is '业务流水号';
comment on column ${iol_schema}.icms_fkd_house_list.areacode is '区域编码';
comment on column ${iol_schema}.icms_fkd_house_list.projectid is '楼盘编号';
comment on column ${iol_schema}.icms_fkd_house_list.isvacant is '是否空置';
comment on column ${iol_schema}.icms_fkd_house_list.getmode is '取得方式';
comment on column ${iol_schema}.icms_fkd_house_list.propertyrightduedate is '土地使用权到期日期';
comment on column ${iol_schema}.icms_fkd_house_list.hsdecoratestate is '房产装修情况';
comment on column ${iol_schema}.icms_fkd_house_list.pledgeind is '是否本次抵押';
comment on column ${iol_schema}.icms_fkd_house_list.hscoveredarea is '建筑面积';
comment on column ${iol_schema}.icms_fkd_house_list.mourent is '月租金';
comment on column ${iol_schema}.icms_fkd_house_list.frontcode is '朝向';
comment on column ${iol_schema}.icms_fkd_house_list.rentcycle is '租金收缴周期';
comment on column ${iol_schema}.icms_fkd_house_list.propertytype is '房产类型';
comment on column ${iol_schema}.icms_fkd_house_list.floorno is '楼层';
comment on column ${iol_schema}.icms_fkd_house_list.roomno is '单元室';
comment on column ${iol_schema}.icms_fkd_house_list.buildingdate is '建成年份';
comment on column ${iol_schema}.icms_fkd_house_list.isclearinghouse is '是否清房';
comment on column ${iol_schema}.icms_fkd_house_list.landcategory is '土地性质';
comment on column ${iol_schema}.icms_fkd_house_list.spareroomaddr is '备用房地址';
comment on column ${iol_schema}.icms_fkd_house_list.gurtrate is '担保率';
comment on column ${iol_schema}.icms_fkd_house_list.projectaddr is '楼盘位置';
comment on column ${iol_schema}.icms_fkd_house_list.assessmentcom is '评估公司名称';
comment on column ${iol_schema}.icms_fkd_house_list.partnerobligeeind is '配偶权利人标志';
comment on column ${iol_schema}.icms_fkd_house_list.totalfloor is '总楼层';
comment on column ${iol_schema}.icms_fkd_house_list.isevlbld is '是否电梯楼';
comment on column ${iol_schema}.icms_fkd_house_list.contmode is '房产所属人联系方式';
comment on column ${iol_schema}.icms_fkd_house_list.custname is '房产所属人姓名';
comment on column ${iol_schema}.icms_fkd_house_list.propertydueyear is '土地使用年限';
comment on column ${iol_schema}.icms_fkd_house_list.valuationkh is '客户录入评估总价';
comment on column ${iol_schema}.icms_fkd_house_list.iscompleted is '';
comment on column ${iol_schema}.icms_fkd_house_list.yearlyrental is '';
comment on column ${iol_schema}.icms_fkd_house_list.houseid is '';
comment on column ${iol_schema}.icms_fkd_house_list.valuationdzy is '';
comment on column ${iol_schema}.icms_fkd_house_list.address is '';
comment on column ${iol_schema}.icms_fkd_house_list.reltype is '';
comment on column ${iol_schema}.icms_fkd_house_list.start_dt is '开始时间';
comment on column ${iol_schema}.icms_fkd_house_list.end_dt is '结束时间';
comment on column ${iol_schema}.icms_fkd_house_list.id_mark is '增删标志';
comment on column ${iol_schema}.icms_fkd_house_list.etl_timestamp is 'ETL处理时间戳';
