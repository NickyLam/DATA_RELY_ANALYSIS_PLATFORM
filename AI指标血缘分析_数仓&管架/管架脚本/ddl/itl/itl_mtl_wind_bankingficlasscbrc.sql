/*
Purpose:    技术缓冲层-建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py itl mtl_wind_bankingficlasscbrc
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${itl_schema}.mtl_wind_bankingficlasscbrc
whenever sqlerror continue none;
drop table ${itl_schema}.mtl_wind_bankingficlasscbrc purge;

whenever sqlerror exit sql.sqlcode;
create table ${itl_schema}.mtl_wind_bankingficlasscbrc(
    etl_dt date -- ETL处理日期
    ,object_id varchar2(100) -- 对象ID
    ,s_info_compcode varchar2(40) -- 公司ID
    ,s_info_compname varchar2(100) -- 公司名称
    ,s_info_typecode varchar2(50) -- 分类代码
    ,entry_dt varchar2(8) -- 纳入日期
    ,remove_dt varchar2(8) -- 剔除日期
    ,cur_sign varchar2(10) -- 最新标志
    ,start_dt date -- 开始时间
    ,end_dt date -- 结束时间
    ,id_mark varchar2(10) -- 增删标志
    ,etl_timestamp timestamp -- ETL处理时间戳
)
partition by list(etl_dt)(
    partition p_19000101 values (to_date('19000101','yyyymmdd'))
)
storage (initial 1024k next 1024k)
compress ${option_switch} for query high
nologging
;

-- grant
grant select on ${itl_schema}.mtl_wind_bankingficlasscbrc to ${iol_schema};

-- comment
comment on table ${itl_schema}.mtl_wind_bankingficlasscbrc is '国内银行业金融机构分类(银监会)';
comment on column ${itl_schema}.mtl_wind_bankingficlasscbrc.etl_dt is 'ETL处理日期';
comment on column ${itl_schema}.mtl_wind_bankingficlasscbrc.object_id is '对象ID';
comment on column ${itl_schema}.mtl_wind_bankingficlasscbrc.s_info_compcode is '公司ID';
comment on column ${itl_schema}.mtl_wind_bankingficlasscbrc.s_info_compname is '公司名称';
comment on column ${itl_schema}.mtl_wind_bankingficlasscbrc.s_info_typecode is '分类代码';
comment on column ${itl_schema}.mtl_wind_bankingficlasscbrc.entry_dt is '纳入日期';
comment on column ${itl_schema}.mtl_wind_bankingficlasscbrc.remove_dt is '剔除日期';
comment on column ${itl_schema}.mtl_wind_bankingficlasscbrc.cur_sign is '最新标志';
comment on column ${itl_schema}.mtl_wind_bankingficlasscbrc.start_dt is '开始时间';
comment on column ${itl_schema}.mtl_wind_bankingficlasscbrc.end_dt is '结束时间';
comment on column ${itl_schema}.mtl_wind_bankingficlasscbrc.id_mark is '增删标志';
comment on column ${itl_schema}.mtl_wind_bankingficlasscbrc.etl_dt is 'ETL处理日期';
comment on column ${itl_schema}.mtl_wind_bankingficlasscbrc.etl_timestamp is 'ETL处理时间戳';
