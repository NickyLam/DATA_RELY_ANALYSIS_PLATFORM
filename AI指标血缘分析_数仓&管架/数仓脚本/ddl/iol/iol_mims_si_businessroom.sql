/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol mims_si_businessroom
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.mims_si_businessroom
whenever sqlerror continue none;
drop table ${iol_schema}.mims_si_businessroom purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.mims_si_businessroom(
    sccode varchar2(48) -- 押品编号
    ,isnewhouse varchar2(3) -- 一手/二手标识
    ,istwotogether varchar2(3) -- 是否两证合一
    ,warrantsno varchar2(1350) -- 房产证/不动产证号
    ,istotal varchar2(3) -- 该产证所属房产是否全部抵押
    ,otherremark varchar2(1500) -- 部分抵押房产的部位描述
    ,contno varchar2(90) -- 房地产买卖合同编号
    ,tradedate varchar2(15) -- 购房日期
    ,tradeprice number(20,2) -- 购房总价
    ,buildingarea number(20,2) -- 建筑面积
    ,usearea number(20,2) -- 实用面积
    ,createyear varchar2(15) -- 建成年份
    ,buildage number(5,2) -- 楼龄(年)
    ,roomstructe varchar2(3) -- 房屋结构类型
    ,province varchar2(90) -- 所在/注册省份
    ,city varchar2(90) -- 所在/注册市
    ,counties varchar2(90) -- 所在县（区）
    ,street varchar2(90) -- 街道/村镇/路名
    ,roomno varchar2(150) -- 门牌号/弄号
    ,address varchar2(300) -- 房产证或不动产证地址/期房预售合同地址
    ,storeyno varchar2(15) -- 层次（标的所在楼层）
    ,totalstoreyno number(22,0) -- 层数（标的所在总楼层）
    ,presentstatus varchar2(3) -- 目前状态
    ,buildrightinfo varchar2(150) -- 房屋产权期限信息
    ,landno varchar2(300) -- 土地证号
    ,landusenature varchar2(3) -- 土地使用权性质
    ,landgainway varchar2(3) -- 土地使用权取得方式
    ,landstartdate varchar2(15) -- 土地使用权起始日期
    ,landenddate varchar2(15) -- 土地使用权到期日期
    ,landuseryear number(3,1) -- 土地使用年限
    ,landusering varchar2(3) -- 土地用途
    ,isotherright varchar2(3) -- 是否有他项权证
    ,remark varchar2(4000) -- 其他说明
    ,isrents varchar2(2) -- 是否租赁
    ,hpaddr varchar2(150) -- 承租人
    ,hiresdate varchar2(15) -- 租赁起始日
    ,hireedate varchar2(15) -- 租赁到期日
    ,hireremark varchar2(300) -- 租赁情况说明
    ,tdcurrency varchar2(5) -- 币种
    ,remainuseyear varchar2(5) -- 剩余使用年限
    ,monmanagementfee number(20,2) -- 
    ,yearlyrental number(20,2) -- 租赁年收入（元）
    ,iscompleted varchar2(3) -- 房屋是否已竣工
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
grant select on ${iol_schema}.mims_si_businessroom to ${iml_schema};
grant select on ${iol_schema}.mims_si_businessroom to ${icl_schema};
grant select on ${iol_schema}.mims_si_businessroom to ${idl_schema};
grant select on ${iol_schema}.mims_si_businessroom to ${iel_schema};

-- comment
comment on table ${iol_schema}.mims_si_businessroom is '商业用房';
comment on column ${iol_schema}.mims_si_businessroom.sccode is '押品编号';
comment on column ${iol_schema}.mims_si_businessroom.isnewhouse is '一手/二手标识';
comment on column ${iol_schema}.mims_si_businessroom.istwotogether is '是否两证合一';
comment on column ${iol_schema}.mims_si_businessroom.warrantsno is '房产证/不动产证号';
comment on column ${iol_schema}.mims_si_businessroom.istotal is '该产证所属房产是否全部抵押';
comment on column ${iol_schema}.mims_si_businessroom.otherremark is '部分抵押房产的部位描述';
comment on column ${iol_schema}.mims_si_businessroom.contno is '房地产买卖合同编号';
comment on column ${iol_schema}.mims_si_businessroom.tradedate is '购房日期';
comment on column ${iol_schema}.mims_si_businessroom.tradeprice is '购房总价';
comment on column ${iol_schema}.mims_si_businessroom.buildingarea is '建筑面积';
comment on column ${iol_schema}.mims_si_businessroom.usearea is '实用面积';
comment on column ${iol_schema}.mims_si_businessroom.createyear is '建成年份';
comment on column ${iol_schema}.mims_si_businessroom.buildage is '楼龄(年)';
comment on column ${iol_schema}.mims_si_businessroom.roomstructe is '房屋结构类型';
comment on column ${iol_schema}.mims_si_businessroom.province is '所在/注册省份';
comment on column ${iol_schema}.mims_si_businessroom.city is '所在/注册市';
comment on column ${iol_schema}.mims_si_businessroom.counties is '所在县（区）';
comment on column ${iol_schema}.mims_si_businessroom.street is '街道/村镇/路名';
comment on column ${iol_schema}.mims_si_businessroom.roomno is '门牌号/弄号';
comment on column ${iol_schema}.mims_si_businessroom.address is '房产证或不动产证地址/期房预售合同地址';
comment on column ${iol_schema}.mims_si_businessroom.storeyno is '层次（标的所在楼层）';
comment on column ${iol_schema}.mims_si_businessroom.totalstoreyno is '层数（标的所在总楼层）';
comment on column ${iol_schema}.mims_si_businessroom.presentstatus is '目前状态';
comment on column ${iol_schema}.mims_si_businessroom.buildrightinfo is '房屋产权期限信息';
comment on column ${iol_schema}.mims_si_businessroom.landno is '土地证号';
comment on column ${iol_schema}.mims_si_businessroom.landusenature is '土地使用权性质';
comment on column ${iol_schema}.mims_si_businessroom.landgainway is '土地使用权取得方式';
comment on column ${iol_schema}.mims_si_businessroom.landstartdate is '土地使用权起始日期';
comment on column ${iol_schema}.mims_si_businessroom.landenddate is '土地使用权到期日期';
comment on column ${iol_schema}.mims_si_businessroom.landuseryear is '土地使用年限';
comment on column ${iol_schema}.mims_si_businessroom.landusering is '土地用途';
comment on column ${iol_schema}.mims_si_businessroom.isotherright is '是否有他项权证';
comment on column ${iol_schema}.mims_si_businessroom.remark is '其他说明';
comment on column ${iol_schema}.mims_si_businessroom.isrents is '是否租赁';
comment on column ${iol_schema}.mims_si_businessroom.hpaddr is '承租人';
comment on column ${iol_schema}.mims_si_businessroom.hiresdate is '租赁起始日';
comment on column ${iol_schema}.mims_si_businessroom.hireedate is '租赁到期日';
comment on column ${iol_schema}.mims_si_businessroom.hireremark is '租赁情况说明';
comment on column ${iol_schema}.mims_si_businessroom.tdcurrency is '币种';
comment on column ${iol_schema}.mims_si_businessroom.remainuseyear is '剩余使用年限';
comment on column ${iol_schema}.mims_si_businessroom.monmanagementfee is '';
comment on column ${iol_schema}.mims_si_businessroom.yearlyrental is '租赁年收入（元）';
comment on column ${iol_schema}.mims_si_businessroom.iscompleted is '房屋是否已竣工';
comment on column ${iol_schema}.mims_si_businessroom.start_dt is '开始时间';
comment on column ${iol_schema}.mims_si_businessroom.end_dt is '结束时间';
comment on column ${iol_schema}.mims_si_businessroom.id_mark is '增删标志';
comment on column ${iol_schema}.mims_si_businessroom.etl_timestamp is 'ETL处理时间戳';
