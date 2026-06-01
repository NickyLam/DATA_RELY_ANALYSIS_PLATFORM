/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol orms_t21_disclosure_data
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.orms_t21_disclosure_data
whenever sqlerror continue none;
drop table ${iol_schema}.orms_t21_disclosure_data purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.orms_t21_disclosure_data(
    id varchar2(15) -- id，主键
    ,seq varchar2(15) -- 披露报表类型序号
    ,type varchar2(300) -- 纳入内部损失乘数计算的损失事件（中文）
    ,year varchar2(48) -- 年度(只用于g4d2)
    ,datat1 varchar2(48) -- 最近第一年数据(万元)
    ,datat2 varchar2(48) -- 最近第二年数据(万元)
    ,datat3 varchar2(48) -- 最近第三年数据(万元)
    ,datat4 varchar2(48) -- 最近第四年数据(万元)
    ,datat5 varchar2(48) -- 最近第五年数据(万元)
    ,datat6 varchar2(48) -- 最近第六年数据(万元)
    ,datat7 varchar2(48) -- 最近第七年数据(万元)
    ,datat8 varchar2(48) -- 最近第八年数据(万元)
    ,datat9 varchar2(48) -- 最近第九年数据(万元)
    ,datat10 varchar2(48) -- 最近第十年数据(万元)
    ,average varchar2(48) -- 平均值(万元)
    ,sumtotal varchar2(48) -- 合计(万元)
    ,versions_id varchar2(48) -- 披露报表版本id
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
grant select on ${iol_schema}.orms_t21_disclosure_data to ${iml_schema};
grant select on ${iol_schema}.orms_t21_disclosure_data to ${icl_schema};
grant select on ${iol_schema}.orms_t21_disclosure_data to ${idl_schema};
grant select on ${iol_schema}.orms_t21_disclosure_data to ${iel_schema};

-- comment
comment on table ${iol_schema}.orms_t21_disclosure_data is '披露报表-统计数据';
comment on column ${iol_schema}.orms_t21_disclosure_data.id is 'id，主键';
comment on column ${iol_schema}.orms_t21_disclosure_data.seq is '披露报表类型序号';
comment on column ${iol_schema}.orms_t21_disclosure_data.type is '纳入内部损失乘数计算的损失事件（中文）';
comment on column ${iol_schema}.orms_t21_disclosure_data.year is '年度(只用于g4d2)';
comment on column ${iol_schema}.orms_t21_disclosure_data.datat1 is '最近第一年数据(万元)';
comment on column ${iol_schema}.orms_t21_disclosure_data.datat2 is '最近第二年数据(万元)';
comment on column ${iol_schema}.orms_t21_disclosure_data.datat3 is '最近第三年数据(万元)';
comment on column ${iol_schema}.orms_t21_disclosure_data.datat4 is '最近第四年数据(万元)';
comment on column ${iol_schema}.orms_t21_disclosure_data.datat5 is '最近第五年数据(万元)';
comment on column ${iol_schema}.orms_t21_disclosure_data.datat6 is '最近第六年数据(万元)';
comment on column ${iol_schema}.orms_t21_disclosure_data.datat7 is '最近第七年数据(万元)';
comment on column ${iol_schema}.orms_t21_disclosure_data.datat8 is '最近第八年数据(万元)';
comment on column ${iol_schema}.orms_t21_disclosure_data.datat9 is '最近第九年数据(万元)';
comment on column ${iol_schema}.orms_t21_disclosure_data.datat10 is '最近第十年数据(万元)';
comment on column ${iol_schema}.orms_t21_disclosure_data.average is '平均值(万元)';
comment on column ${iol_schema}.orms_t21_disclosure_data.sumtotal is '合计(万元)';
comment on column ${iol_schema}.orms_t21_disclosure_data.versions_id is '披露报表版本id';
comment on column ${iol_schema}.orms_t21_disclosure_data.start_dt is '开始时间';
comment on column ${iol_schema}.orms_t21_disclosure_data.end_dt is '结束时间';
comment on column ${iol_schema}.orms_t21_disclosure_data.id_mark is '增删标志';
comment on column ${iol_schema}.orms_t21_disclosure_data.etl_timestamp is 'ETL处理时间戳';
