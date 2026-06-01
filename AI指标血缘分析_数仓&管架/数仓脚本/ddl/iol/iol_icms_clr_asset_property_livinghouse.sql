/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol icms_clr_asset_property_livinghouse
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.icms_clr_asset_property_livinghouse
whenever sqlerror continue none;
drop table ${iol_schema}.icms_clr_asset_property_livinghouse purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.icms_clr_asset_property_livinghouse(
    clrid varchar2(32) -- 押品编号
    ,houseflag varchar2(2) -- 现房/期房标识
    ,preregistno varchar2(60) -- 预购商品房预告登记证明号
    ,preroyno varchar2(60) -- 预售许可证编号
    ,prevalidity date -- 预售许可证有效期
    ,predeliver date -- 预计房屋交付时间
    ,pregaindate date -- 预计取得不动产证时间
    ,isnewhouse varchar2(2) -- 一手/二手标识
    ,istwotogether varchar2(2) -- 是否两证合一
    ,houseno varchar2(900) -- 房产证号
    ,licenceno varchar2(60) -- 销售许可证编号
    ,istotal varchar2(2) -- 该产证所属房产是否全部抵押
    ,otherremark varchar2(1000) -- 部分抵押房产的部位描述
    ,contno varchar2(120) -- 房地产买卖合同编号
    ,tradedate date -- 购房日期
    ,tradeprice number(20,2) -- 购房总价
    ,issalerecord varchar2(2) -- 是否销售备案
    ,isapply varchar2(2) -- 是否本次申请所购房产
    ,isonlyhouse varchar2(2) -- 抵押住房是否权属人唯一住所
    ,buildingarea number(20,2) -- 建筑面积
    ,usearea number(20,2) -- 实用面积
    ,createyear varchar2(10) -- 建成年份
    ,limitinfo varchar2(100) -- 房屋产权期限信息
    ,buildage number(38,0) -- 楼龄(年)
    ,flattype varchar2(2) -- 套型
    ,orientations varchar2(2) -- 朝向
    ,remainuseyear number(38,0) -- 剩余使用年限
    ,roomstructe varchar2(60) -- 房屋结构类型
    ,roomstatus varchar2(60) -- 房屋状态
    ,province varchar2(60) -- 所在/注册省份
    ,city varchar2(60) -- 所在/注册市
    ,counties varchar2(60) -- 所在县（区）
    ,street varchar2(400) -- 街道/村镇/路名
    ,roomno varchar2(120) -- 门牌号/弄号
    ,buildingno varchar2(120) -- 楼号室号
    ,address varchar2(400) -- 房产证或不动产证地址/期房预售合同地址
    ,buildingname varchar2(100) -- 楼盘（社区）名称
    ,plotratio number(5,2) -- 容积率
    ,storeyno varchar2(20) -- 层次（标的所在楼层）
    ,totalstoreyno number(38,0) -- 层数（标的所在总楼层）
    ,landno varchar2(200) -- 土地证号
    ,landusenature varchar2(2) -- 土地使用权性质
    ,landusearea number(20,2) -- 土地使用面积
    ,landgainway varchar2(2) -- 土地使用权取得方式
    ,landstartdate date -- 土地使用权起始日期
    ,landenddate date -- 土地使用权到期日期
    ,landuseryear number(3,1) -- 土地使用年限
    ,landusering varchar2(2) -- 土地用途
    ,isotherright varchar2(2) -- 是否有他项权证
    ,remark varchar2(4000) -- 其他说明
    ,isrents varchar2(3) -- 是否租赁
    ,hpaddr varchar2(200) -- 承租人
    ,hiresdate date -- 租赁起始日
    ,hireedate date -- 租赁到期日
    ,hireremark varchar2(200) -- 租赁情况说明
    ,tdcurrency varchar2(3) -- 币种
    ,monmanagementfee number(20,2) -- 月物业管理费
    ,iscompleted varchar2(2) -- 房屋是否已竣工
    ,yearlyrental number(20,2) -- 租赁年收入（元）
    ,buildingnumber varchar2(30) -- 房屋编号
    ,roomnumber varchar2(30) -- 楼栋编号
    ,migtflag varchar2(80) -- 迁移标识：rs rcr ilc upl mim
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
grant select on ${iol_schema}.icms_clr_asset_property_livinghouse to ${iml_schema};
grant select on ${iol_schema}.icms_clr_asset_property_livinghouse to ${icl_schema};
grant select on ${iol_schema}.icms_clr_asset_property_livinghouse to ${idl_schema};
grant select on ${iol_schema}.icms_clr_asset_property_livinghouse to ${iel_schema};

-- comment
comment on table ${iol_schema}.icms_clr_asset_property_livinghouse is '房地产类之居住用房信息表';
comment on column ${iol_schema}.icms_clr_asset_property_livinghouse.clrid is '押品编号';
comment on column ${iol_schema}.icms_clr_asset_property_livinghouse.houseflag is '现房/期房标识';
comment on column ${iol_schema}.icms_clr_asset_property_livinghouse.preregistno is '预购商品房预告登记证明号';
comment on column ${iol_schema}.icms_clr_asset_property_livinghouse.preroyno is '预售许可证编号';
comment on column ${iol_schema}.icms_clr_asset_property_livinghouse.prevalidity is '预售许可证有效期';
comment on column ${iol_schema}.icms_clr_asset_property_livinghouse.predeliver is '预计房屋交付时间';
comment on column ${iol_schema}.icms_clr_asset_property_livinghouse.pregaindate is '预计取得不动产证时间';
comment on column ${iol_schema}.icms_clr_asset_property_livinghouse.isnewhouse is '一手/二手标识';
comment on column ${iol_schema}.icms_clr_asset_property_livinghouse.istwotogether is '是否两证合一';
comment on column ${iol_schema}.icms_clr_asset_property_livinghouse.houseno is '房产证号';
comment on column ${iol_schema}.icms_clr_asset_property_livinghouse.licenceno is '销售许可证编号';
comment on column ${iol_schema}.icms_clr_asset_property_livinghouse.istotal is '该产证所属房产是否全部抵押';
comment on column ${iol_schema}.icms_clr_asset_property_livinghouse.otherremark is '部分抵押房产的部位描述';
comment on column ${iol_schema}.icms_clr_asset_property_livinghouse.contno is '房地产买卖合同编号';
comment on column ${iol_schema}.icms_clr_asset_property_livinghouse.tradedate is '购房日期';
comment on column ${iol_schema}.icms_clr_asset_property_livinghouse.tradeprice is '购房总价';
comment on column ${iol_schema}.icms_clr_asset_property_livinghouse.issalerecord is '是否销售备案';
comment on column ${iol_schema}.icms_clr_asset_property_livinghouse.isapply is '是否本次申请所购房产';
comment on column ${iol_schema}.icms_clr_asset_property_livinghouse.isonlyhouse is '抵押住房是否权属人唯一住所';
comment on column ${iol_schema}.icms_clr_asset_property_livinghouse.buildingarea is '建筑面积';
comment on column ${iol_schema}.icms_clr_asset_property_livinghouse.usearea is '实用面积';
comment on column ${iol_schema}.icms_clr_asset_property_livinghouse.createyear is '建成年份';
comment on column ${iol_schema}.icms_clr_asset_property_livinghouse.limitinfo is '房屋产权期限信息';
comment on column ${iol_schema}.icms_clr_asset_property_livinghouse.buildage is '楼龄(年)';
comment on column ${iol_schema}.icms_clr_asset_property_livinghouse.flattype is '套型';
comment on column ${iol_schema}.icms_clr_asset_property_livinghouse.orientations is '朝向';
comment on column ${iol_schema}.icms_clr_asset_property_livinghouse.remainuseyear is '剩余使用年限';
comment on column ${iol_schema}.icms_clr_asset_property_livinghouse.roomstructe is '房屋结构类型';
comment on column ${iol_schema}.icms_clr_asset_property_livinghouse.roomstatus is '房屋状态';
comment on column ${iol_schema}.icms_clr_asset_property_livinghouse.province is '所在/注册省份';
comment on column ${iol_schema}.icms_clr_asset_property_livinghouse.city is '所在/注册市';
comment on column ${iol_schema}.icms_clr_asset_property_livinghouse.counties is '所在县（区）';
comment on column ${iol_schema}.icms_clr_asset_property_livinghouse.street is '街道/村镇/路名';
comment on column ${iol_schema}.icms_clr_asset_property_livinghouse.roomno is '门牌号/弄号';
comment on column ${iol_schema}.icms_clr_asset_property_livinghouse.buildingno is '楼号室号';
comment on column ${iol_schema}.icms_clr_asset_property_livinghouse.address is '房产证或不动产证地址/期房预售合同地址';
comment on column ${iol_schema}.icms_clr_asset_property_livinghouse.buildingname is '楼盘（社区）名称';
comment on column ${iol_schema}.icms_clr_asset_property_livinghouse.plotratio is '容积率';
comment on column ${iol_schema}.icms_clr_asset_property_livinghouse.storeyno is '层次（标的所在楼层）';
comment on column ${iol_schema}.icms_clr_asset_property_livinghouse.totalstoreyno is '层数（标的所在总楼层）';
comment on column ${iol_schema}.icms_clr_asset_property_livinghouse.landno is '土地证号';
comment on column ${iol_schema}.icms_clr_asset_property_livinghouse.landusenature is '土地使用权性质';
comment on column ${iol_schema}.icms_clr_asset_property_livinghouse.landusearea is '土地使用面积';
comment on column ${iol_schema}.icms_clr_asset_property_livinghouse.landgainway is '土地使用权取得方式';
comment on column ${iol_schema}.icms_clr_asset_property_livinghouse.landstartdate is '土地使用权起始日期';
comment on column ${iol_schema}.icms_clr_asset_property_livinghouse.landenddate is '土地使用权到期日期';
comment on column ${iol_schema}.icms_clr_asset_property_livinghouse.landuseryear is '土地使用年限';
comment on column ${iol_schema}.icms_clr_asset_property_livinghouse.landusering is '土地用途';
comment on column ${iol_schema}.icms_clr_asset_property_livinghouse.isotherright is '是否有他项权证';
comment on column ${iol_schema}.icms_clr_asset_property_livinghouse.remark is '其他说明';
comment on column ${iol_schema}.icms_clr_asset_property_livinghouse.isrents is '是否租赁';
comment on column ${iol_schema}.icms_clr_asset_property_livinghouse.hpaddr is '承租人';
comment on column ${iol_schema}.icms_clr_asset_property_livinghouse.hiresdate is '租赁起始日';
comment on column ${iol_schema}.icms_clr_asset_property_livinghouse.hireedate is '租赁到期日';
comment on column ${iol_schema}.icms_clr_asset_property_livinghouse.hireremark is '租赁情况说明';
comment on column ${iol_schema}.icms_clr_asset_property_livinghouse.tdcurrency is '币种';
comment on column ${iol_schema}.icms_clr_asset_property_livinghouse.monmanagementfee is '月物业管理费';
comment on column ${iol_schema}.icms_clr_asset_property_livinghouse.iscompleted is '房屋是否已竣工';
comment on column ${iol_schema}.icms_clr_asset_property_livinghouse.yearlyrental is '租赁年收入（元）';
comment on column ${iol_schema}.icms_clr_asset_property_livinghouse.buildingnumber is '房屋编号';
comment on column ${iol_schema}.icms_clr_asset_property_livinghouse.roomnumber is '楼栋编号';
comment on column ${iol_schema}.icms_clr_asset_property_livinghouse.migtflag is '迁移标识：rs rcr ilc upl mim';
comment on column ${iol_schema}.icms_clr_asset_property_livinghouse.start_dt is '开始时间';
comment on column ${iol_schema}.icms_clr_asset_property_livinghouse.end_dt is '结束时间';
comment on column ${iol_schema}.icms_clr_asset_property_livinghouse.id_mark is '增删标志';
comment on column ${iol_schema}.icms_clr_asset_property_livinghouse.etl_timestamp is 'ETL处理时间戳';
