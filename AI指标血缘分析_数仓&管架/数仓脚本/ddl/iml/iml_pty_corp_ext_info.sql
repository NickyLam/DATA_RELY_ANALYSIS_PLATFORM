/*
Purpose:    整合模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iml pty_corp_ext_info
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iml_schema}.pty_corp_ext_info
whenever sqlerror continue none;
drop table ${iml_schema}.pty_corp_ext_info purge;

whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.pty_corp_ext_info(
    party_id varchar2(100) -- 当事人编号
    ,lp_id varchar2(100) -- 法人编号
    ,fst_idtfy_benefc_flg varchar2(30) -- 初次识别受益人标志
    ,benefc_attr_cd_comb varchar2(30) -- 受益所有人属性代码组合
    ,benefc_cd varchar2(30) -- 受益所有人代码
    ,public_market_std_flg varchar2(10) -- 仅公开市场标准化业务标志
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
grant select on ${iml_schema}.pty_corp_ext_info to ${icl_schema};
grant select on ${iml_schema}.pty_corp_ext_info to ${idl_schema};
grant select on ${iml_schema}.pty_corp_ext_info to ${iel_schema};

-- comment
comment on table ${iml_schema}.pty_corp_ext_info is '公司当事人扩展信息';
comment on column ${iml_schema}.pty_corp_ext_info.party_id is '当事人编号';
comment on column ${iml_schema}.pty_corp_ext_info.lp_id is '法人编号';
comment on column ${iml_schema}.pty_corp_ext_info.fst_idtfy_benefc_flg is '初次识别受益人标志';
comment on column ${iml_schema}.pty_corp_ext_info.benefc_attr_cd_comb is '受益所有人属性代码组合';
comment on column ${iml_schema}.pty_corp_ext_info.benefc_cd is '受益所有人代码';
comment on column ${iml_schema}.pty_corp_ext_info.public_market_std_flg is '仅公开市场标准化业务标志';
comment on column ${iml_schema}.pty_corp_ext_info.start_dt is '开始时间';
comment on column ${iml_schema}.pty_corp_ext_info.end_dt is '结束时间';
comment on column ${iml_schema}.pty_corp_ext_info.id_mark is '增删标志';
comment on column ${iml_schema}.pty_corp_ext_info.src_table_name is '源表名称';
comment on column ${iml_schema}.pty_corp_ext_info.job_cd is '任务编码';
comment on column ${iml_schema}.pty_corp_ext_info.etl_timestamp is 'ETL处理时间戳';
