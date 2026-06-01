/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol isbs_adr
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.isbs_adr
whenever sqlerror continue none;
drop table ${iol_schema}.isbs_adr purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.isbs_adr(
    inr varchar2(12) -- 内部唯一id号
    ,extkey varchar2(24) -- 地址关键字
    ,nam varchar2(60) -- 地址名称
    ,bic varchar2(17) -- 通知行swift代码
    ,bicaut varchar2(2) -- swift连接标志
    ,bid varchar2(53) -- 支行权限
    ,blz varchar2(12) -- 德国的空代码
    ,clc varchar2(53) -- 国家的空代码
    ,dpt varchar2(53) -- 机构
    ,eml varchar2(120) -- 邮件信箱
    ,fax1 varchar2(30) -- 电传1
    ,fax2 varchar2(30) -- 电传2
    ,nam1 varchar2(53) -- 名称1
    ,nam2 varchar2(53) -- 名称2
    ,nam3 varchar2(53) -- 名称3
    ,str1 varchar2(53) -- 街道1
    ,str2 varchar2(53) -- 街道2
    ,loczip varchar2(15) -- 邮政编码
    ,loctxt varchar2(38) -- 城市名称
    ,loc2 varchar2(53) -- 城市区域
    ,loccty varchar2(3) -- 住址
    ,cortyp varchar2(5) -- 通信方式
    ,pob varchar2(53) -- 邮箱号码
    ,pobzip varchar2(15) -- 邮政编码
    ,pobtxt varchar2(38) -- 国家名称
    ,tel1 varchar2(30) -- 电话1
    ,tel2 varchar2(30) -- 电话2
    ,tid varchar2(35) -- 收单行机构代码
    ,tlx varchar2(30) -- 电报号码
    ,tlxaut varchar2(2) -- 电报权限修改
    ,uil varchar2(3) -- 默认语种
    ,ver varchar2(6) -- 版本号
    ,manmod varchar2(2) -- 手动更改标志
    ,rtgflg varchar2(2) -- rtgs标志
    ,tarflg varchar2(2) -- target标志
    ,dtacid varchar2(35) -- dta messages的客户地址
    ,dtecid varchar2(35) -- dte messages的客户地址
    ,etgextkey varchar2(12) -- 用户组别关键字
    ,adr1 varchar2(60) -- 地址1
    ,adr2 varchar2(60) -- 地址2
    ,adr3 varchar2(60) -- 地址3
    ,adr4 varchar2(60) -- 地址4
    ,namelc varchar2(324) -- 人行名称
    ,adrelc varchar2(324) -- 人行地址
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
grant select on ${iol_schema}.isbs_adr to ${iml_schema};
grant select on ${iol_schema}.isbs_adr to ${icl_schema};
grant select on ${iol_schema}.isbs_adr to ${idl_schema};
grant select on ${iol_schema}.isbs_adr to ${iel_schema};

-- comment
comment on table ${iol_schema}.isbs_adr is '存放所有Party的地址信息';
comment on column ${iol_schema}.isbs_adr.inr is '内部唯一id号';
comment on column ${iol_schema}.isbs_adr.extkey is '地址关键字';
comment on column ${iol_schema}.isbs_adr.nam is '地址名称';
comment on column ${iol_schema}.isbs_adr.bic is '通知行swift代码';
comment on column ${iol_schema}.isbs_adr.bicaut is 'swift连接标志';
comment on column ${iol_schema}.isbs_adr.bid is '支行权限';
comment on column ${iol_schema}.isbs_adr.blz is '德国的空代码';
comment on column ${iol_schema}.isbs_adr.clc is '国家的空代码';
comment on column ${iol_schema}.isbs_adr.dpt is '机构';
comment on column ${iol_schema}.isbs_adr.eml is '邮件信箱';
comment on column ${iol_schema}.isbs_adr.fax1 is '电传1';
comment on column ${iol_schema}.isbs_adr.fax2 is '电传2';
comment on column ${iol_schema}.isbs_adr.nam1 is '名称1';
comment on column ${iol_schema}.isbs_adr.nam2 is '名称2';
comment on column ${iol_schema}.isbs_adr.nam3 is '名称3';
comment on column ${iol_schema}.isbs_adr.str1 is '街道1';
comment on column ${iol_schema}.isbs_adr.str2 is '街道2';
comment on column ${iol_schema}.isbs_adr.loczip is '邮政编码';
comment on column ${iol_schema}.isbs_adr.loctxt is '城市名称';
comment on column ${iol_schema}.isbs_adr.loc2 is '城市区域';
comment on column ${iol_schema}.isbs_adr.loccty is '住址';
comment on column ${iol_schema}.isbs_adr.cortyp is '通信方式';
comment on column ${iol_schema}.isbs_adr.pob is '邮箱号码';
comment on column ${iol_schema}.isbs_adr.pobzip is '邮政编码';
comment on column ${iol_schema}.isbs_adr.pobtxt is '国家名称';
comment on column ${iol_schema}.isbs_adr.tel1 is '电话1';
comment on column ${iol_schema}.isbs_adr.tel2 is '电话2';
comment on column ${iol_schema}.isbs_adr.tid is '收单行机构代码';
comment on column ${iol_schema}.isbs_adr.tlx is '电报号码';
comment on column ${iol_schema}.isbs_adr.tlxaut is '电报权限修改';
comment on column ${iol_schema}.isbs_adr.uil is '默认语种';
comment on column ${iol_schema}.isbs_adr.ver is '版本号';
comment on column ${iol_schema}.isbs_adr.manmod is '手动更改标志';
comment on column ${iol_schema}.isbs_adr.rtgflg is 'rtgs标志';
comment on column ${iol_schema}.isbs_adr.tarflg is 'target标志';
comment on column ${iol_schema}.isbs_adr.dtacid is 'dta messages的客户地址';
comment on column ${iol_schema}.isbs_adr.dtecid is 'dte messages的客户地址';
comment on column ${iol_schema}.isbs_adr.etgextkey is '用户组别关键字';
comment on column ${iol_schema}.isbs_adr.adr1 is '地址1';
comment on column ${iol_schema}.isbs_adr.adr2 is '地址2';
comment on column ${iol_schema}.isbs_adr.adr3 is '地址3';
comment on column ${iol_schema}.isbs_adr.adr4 is '地址4';
comment on column ${iol_schema}.isbs_adr.namelc is '人行名称';
comment on column ${iol_schema}.isbs_adr.adrelc is '人行地址';
comment on column ${iol_schema}.isbs_adr.start_dt is '开始时间';
comment on column ${iol_schema}.isbs_adr.end_dt is '结束时间';
comment on column ${iol_schema}.isbs_adr.id_mark is '增删标志';
comment on column ${iol_schema}.isbs_adr.etl_timestamp is 'ETL处理时间戳';
