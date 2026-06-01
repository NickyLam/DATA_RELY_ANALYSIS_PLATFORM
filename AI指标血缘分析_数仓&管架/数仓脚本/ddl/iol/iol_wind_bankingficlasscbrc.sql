/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol wind_bankingficlasscbrc
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.wind_bankingficlasscbrc
whenever sqlerror continue none;
drop table ${iol_schema}.wind_bankingficlasscbrc purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.wind_bankingficlasscbrc(
    object_id varchar2(150) -- 对象ID
    ,s_info_compcode varchar2(60) -- 公司ID
    ,s_info_compname varchar2(150) -- 公司名称
    ,s_info_typecode varchar2(75) -- 分类代码
    ,entry_dt varchar2(12) -- 纳入日期
    ,remove_dt varchar2(12) -- 剔除日期
    ,cur_sign varchar2(15) -- 最新标志
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
grant select on ${iol_schema}.wind_bankingficlasscbrc to ${iml_schema};
grant select on ${iol_schema}.wind_bankingficlasscbrc to ${icl_schema};
grant select on ${iol_schema}.wind_bankingficlasscbrc to ${idl_schema};
grant select on ${iol_schema}.wind_bankingficlasscbrc to ${iel_schema};

-- comment
comment on table ${iol_schema}.wind_bankingficlasscbrc is '国内银行业金融机构分类(银监会)';
comment on column ${iol_schema}.wind_bankingficlasscbrc.object_id is '对象ID';
comment on column ${iol_schema}.wind_bankingficlasscbrc.s_info_compcode is '公司ID';
comment on column ${iol_schema}.wind_bankingficlasscbrc.s_info_compname is '公司名称';
comment on column ${iol_schema}.wind_bankingficlasscbrc.s_info_typecode is '分类代码';
comment on column ${iol_schema}.wind_bankingficlasscbrc.entry_dt is '纳入日期';
comment on column ${iol_schema}.wind_bankingficlasscbrc.remove_dt is '剔除日期';
comment on column ${iol_schema}.wind_bankingficlasscbrc.cur_sign is '最新标志';
comment on column ${iol_schema}.wind_bankingficlasscbrc.start_dt is '开始时间';
comment on column ${iol_schema}.wind_bankingficlasscbrc.end_dt is '结束时间';
comment on column ${iol_schema}.wind_bankingficlasscbrc.id_mark is '增删标志';
comment on column ${iol_schema}.wind_bankingficlasscbrc.etl_timestamp is 'ETL处理时间戳';
