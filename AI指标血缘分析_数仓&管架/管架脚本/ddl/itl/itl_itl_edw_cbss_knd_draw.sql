/*
Purpose:    应用集市层-建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py itl itl_edw_cbss_knd_draw
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${itl_schema}.itl_edw_cbss_knd_draw
whenever sqlerror continue none;
drop table ${itl_schema}.itl_edw_cbss_knd_draw purge;

whenever sqlerror exit sql.sqlcode;
create table ${itl_schema}.itl_edw_cbss_knd_draw(
    etl_dt date -- 数据日期
    ,dcmttp varchar2(3) -- 凭证类型
    ,initno varchar2(20) -- 起始号码
    ,finlno varchar2(20) -- 结束号码
    ,dctpid varchar2(3) -- 凭证管理ID
    ,dcmtnm number(38) -- 凭证数量
    ,csbxno varchar2(6) -- 尾箱号
    ,drawtg varchar2(1) -- 状态
    ,outflg varchar2(1) -- 0:网点;1:外出中;2:外出;3:返回中
    ,etl_timestamp timestamp -- ETL处理时间戳
   -- ,job_cd varchar2(10) -- 任务编码
   -- ,etl_timestamp timestamp -- ETL处理时间戳
)
partition by list(etl_dt)(
    partition p_19000101 values (to_date('19000101','yyyymmdd'))
)
storage (initial 1024k next 1024k)
compress ${option_switch} for query high
nologging
;

-- grant
grant select on ${itl_schema}.itl_edw_cbss_knd_draw to ${iel_schema};

-- comment
comment on table ${itl_schema}.itl_edw_cbss_knd_draw is '尾箱明细登记簿';
comment on column ${itl_schema}.itl_edw_cbss_knd_draw.etl_dt is '数据日期';
comment on column ${itl_schema}.itl_edw_cbss_knd_draw.dcmttp is '凭证类型';
comment on column ${itl_schema}.itl_edw_cbss_knd_draw.initno is '起始号码';
comment on column ${itl_schema}.itl_edw_cbss_knd_draw.finlno is '结束号码';
comment on column ${itl_schema}.itl_edw_cbss_knd_draw.dctpid is '凭证管理ID';
comment on column ${itl_schema}.itl_edw_cbss_knd_draw.dcmtnm is '凭证数量';
comment on column ${itl_schema}.itl_edw_cbss_knd_draw.csbxno is '尾箱号';
comment on column ${itl_schema}.itl_edw_cbss_knd_draw.drawtg is '状态';
comment on column ${itl_schema}.itl_edw_cbss_knd_draw.outflg is '0:网点;1:外出中;2:外出;3:返回中';
comment on column ${itl_schema}.itl_edw_cbss_knd_draw.etl_timestamp is 'ETL处理时间戳';