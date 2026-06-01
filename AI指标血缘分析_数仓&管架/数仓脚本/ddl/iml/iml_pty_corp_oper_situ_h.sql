/*
Purpose:    整合模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iml pty_corp_oper_situ_h
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iml_schema}.pty_corp_oper_situ_h
whenever sqlerror continue none;
drop table ${iml_schema}.pty_corp_oper_situ_h purge;

whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.pty_corp_oper_situ_h(
    party_id varchar2(60) -- 当事人编号
    ,lp_id varchar2(60) -- 法人编号
    ,sorc_sys_cd varchar2(10) -- 源系统代码
    ,net_asset number(30,2) -- 企业净资产
    ,anl_inco number(30,2) -- 年收入
    ,tot_sell_lmt number(30,2) -- 总销售额
    ,tot_asset number(30,2) -- 企业总资产
    ,cbrc_sb_flg varchar2(10) -- 银监小企业标志
    ,start_dt date -- 开始时间
    ,end_dt date -- 结束时间
    ,id_mark varchar2(10) -- 增删标志
    ,src_table_name varchar2(100) -- 源表名称
    ,job_cd varchar2(10) -- 任务编码
    ,etl_timestamp timestamp -- ETL处理时间戳
)
partition by list (job_cd)
subpartition by list (end_dt)
(
   partition p_default values ('default')
   (
         subpartition p_default_19000101 values (to_date('19000101','yyyymmdd'))
         ,subpartition p_default_20991231 values (to_date('20991231','yyyymmdd'))
   )
)
storage (initial 1024k next 1024k)
compress ${option_switch} for query high
nologging
;

-- grant
grant select on ${iml_schema}.pty_corp_oper_situ_h to ${icl_schema};
grant select on ${iml_schema}.pty_corp_oper_situ_h to ${idl_schema};
grant select on ${iml_schema}.pty_corp_oper_situ_h to ${iel_schema};

-- comment
comment on table ${iml_schema}.pty_corp_oper_situ_h is '企业经营情况历史';
comment on column ${iml_schema}.pty_corp_oper_situ_h.party_id is '当事人编号';
comment on column ${iml_schema}.pty_corp_oper_situ_h.lp_id is '法人编号';
comment on column ${iml_schema}.pty_corp_oper_situ_h.sorc_sys_cd is '源系统代码';
comment on column ${iml_schema}.pty_corp_oper_situ_h.net_asset is '企业净资产';
comment on column ${iml_schema}.pty_corp_oper_situ_h.anl_inco is '年收入';
comment on column ${iml_schema}.pty_corp_oper_situ_h.tot_sell_lmt is '总销售额';
comment on column ${iml_schema}.pty_corp_oper_situ_h.tot_asset is '企业总资产';
comment on column ${iml_schema}.pty_corp_oper_situ_h.cbrc_sb_flg is '银监小企业标志';
comment on column ${iml_schema}.pty_corp_oper_situ_h.start_dt is '开始时间';
comment on column ${iml_schema}.pty_corp_oper_situ_h.end_dt is '结束时间';
comment on column ${iml_schema}.pty_corp_oper_situ_h.id_mark is '增删标志';
comment on column ${iml_schema}.pty_corp_oper_situ_h.src_table_name is '源表名称';
comment on column ${iml_schema}.pty_corp_oper_situ_h.job_cd is '任务编码';
comment on column ${iml_schema}.pty_corp_oper_situ_h.etl_timestamp is 'ETL处理时间戳';
