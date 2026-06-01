/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol pams_jxdx_khrl
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.pams_jxdx_khrl
whenever sqlerror continue none;
drop table ${iol_schema}.pams_jxdx_khrl purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.pams_jxdx_khrl(
    jxdxdh number(22,0) -- 绩效对象代号
    ,khh varchar2(45) -- 客户号
    ,khlx varchar2(2) -- 客户类型
    ,jgdh varchar2(15) -- 机构代号
    ,khmc varchar2(750) -- 客户名称
    ,zjlb varchar2(12) -- 证件类别
    ,zjhm varchar2(75) -- 证件号码
    ,khjjxz varchar2(5) -- 客户经济性质
    ,khhylb varchar2(15) -- 客户行员类别
    ,qygm varchar2(2) -- 企业规模
    ,txdz varchar2(750) -- 通讯地址
    ,dwdh varchar2(75) -- 单位电话
    ,dzyj varchar2(75) -- 电子邮件
    ,lxdh varchar2(17) -- 联系电话
    ,khzt varchar2(15) -- 客户状态
    ,khrq number(22,0) -- 客户日期
    ,zczb number(25,4) -- 注册资本
    ,csrq number(22,0) -- 出生日期
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
grant select on ${iol_schema}.pams_jxdx_khrl to ${iml_schema};
grant select on ${iol_schema}.pams_jxdx_khrl to ${icl_schema};
grant select on ${iol_schema}.pams_jxdx_khrl to ${idl_schema};
grant select on ${iol_schema}.pams_jxdx_khrl to ${iel_schema};

-- comment
comment on table ${iol_schema}.pams_jxdx_khrl is '绩效对象-客户认领';
comment on column ${iol_schema}.pams_jxdx_khrl.jxdxdh is '绩效对象代号';
comment on column ${iol_schema}.pams_jxdx_khrl.khh is '客户号';
comment on column ${iol_schema}.pams_jxdx_khrl.khlx is '客户类型';
comment on column ${iol_schema}.pams_jxdx_khrl.jgdh is '机构代号';
comment on column ${iol_schema}.pams_jxdx_khrl.khmc is '客户名称';
comment on column ${iol_schema}.pams_jxdx_khrl.zjlb is '证件类别';
comment on column ${iol_schema}.pams_jxdx_khrl.zjhm is '证件号码';
comment on column ${iol_schema}.pams_jxdx_khrl.khjjxz is '客户经济性质';
comment on column ${iol_schema}.pams_jxdx_khrl.khhylb is '客户行员类别';
comment on column ${iol_schema}.pams_jxdx_khrl.qygm is '企业规模';
comment on column ${iol_schema}.pams_jxdx_khrl.txdz is '通讯地址';
comment on column ${iol_schema}.pams_jxdx_khrl.dwdh is '单位电话';
comment on column ${iol_schema}.pams_jxdx_khrl.dzyj is '电子邮件';
comment on column ${iol_schema}.pams_jxdx_khrl.lxdh is '联系电话';
comment on column ${iol_schema}.pams_jxdx_khrl.khzt is '客户状态';
comment on column ${iol_schema}.pams_jxdx_khrl.khrq is '客户日期';
comment on column ${iol_schema}.pams_jxdx_khrl.zczb is '注册资本';
comment on column ${iol_schema}.pams_jxdx_khrl.csrq is '出生日期';
comment on column ${iol_schema}.pams_jxdx_khrl.start_dt is '开始时间';
comment on column ${iol_schema}.pams_jxdx_khrl.end_dt is '结束时间';
comment on column ${iol_schema}.pams_jxdx_khrl.id_mark is '增删标志';
comment on column ${iol_schema}.pams_jxdx_khrl.etl_timestamp is 'ETL处理时间戳';
