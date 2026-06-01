/*
Purpose:    整合模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iml evt_clear_route_info_h
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iml_schema}.evt_clear_route_info_h
whenever sqlerror continue none;
drop table ${iml_schema}.evt_clear_route_info_h purge;

whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.evt_clear_route_info_h(
    evt_id varchar2(100) -- 事件编号
    ,lp_id varchar2(60) -- 法人编号
    ,pk_seq_num varchar2(60) -- 主键序号
    ,clear_route_name varchar2(750) -- 清算路径名称
    ,cntpty_id varchar2(60) -- 交易对手编号
    ,curr_type_cd varchar2(500) -- 货币类型代码
    ,is_deflt_clear_route_flg varchar2(10) -- 是否默认清算路径标志
    ,acct_bank_bic_code varchar2(750) -- 账户行BIC码
    ,acct_bank_name varchar2(750) -- 账户行名称
    ,acct_num_bk_cn_name varchar2(750) -- 账号行中文名称
    ,acct_bank_acct_num varchar2(500) -- 账户行账号
    ,recv_bank_bic varchar2(750) -- 收款行BIC
    ,recv_bank_name varchar2(750) -- 收款行名称
    ,recv_bank_cn_name varchar2(750) -- 收款行中文名称
    ,recv_bank_acct_num varchar2(500) -- 收款行账号
    ,create_tm date -- 创建时间
    ,modif_tm date -- 修改时间
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
grant select on ${iml_schema}.evt_clear_route_info_h to ${icl_schema};
grant select on ${iml_schema}.evt_clear_route_info_h to ${idl_schema};
grant select on ${iml_schema}.evt_clear_route_info_h to ${iel_schema};

-- comment
comment on table ${iml_schema}.evt_clear_route_info_h is '清算路径信息历史';
comment on column ${iml_schema}.evt_clear_route_info_h.evt_id is '事件编号';
comment on column ${iml_schema}.evt_clear_route_info_h.lp_id is '法人编号';
comment on column ${iml_schema}.evt_clear_route_info_h.pk_seq_num is '主键序号';
comment on column ${iml_schema}.evt_clear_route_info_h.clear_route_name is '清算路径名称';
comment on column ${iml_schema}.evt_clear_route_info_h.cntpty_id is '交易对手编号';
comment on column ${iml_schema}.evt_clear_route_info_h.curr_type_cd is '货币类型代码';
comment on column ${iml_schema}.evt_clear_route_info_h.is_deflt_clear_route_flg is '是否默认清算路径标志';
comment on column ${iml_schema}.evt_clear_route_info_h.acct_bank_bic_code is '账户行BIC码';
comment on column ${iml_schema}.evt_clear_route_info_h.acct_bank_name is '账户行名称';
comment on column ${iml_schema}.evt_clear_route_info_h.acct_num_bk_cn_name is '账号行中文名称';
comment on column ${iml_schema}.evt_clear_route_info_h.acct_bank_acct_num is '账户行账号';
comment on column ${iml_schema}.evt_clear_route_info_h.recv_bank_bic is '收款行BIC';
comment on column ${iml_schema}.evt_clear_route_info_h.recv_bank_name is '收款行名称';
comment on column ${iml_schema}.evt_clear_route_info_h.recv_bank_cn_name is '收款行中文名称';
comment on column ${iml_schema}.evt_clear_route_info_h.recv_bank_acct_num is '收款行账号';
comment on column ${iml_schema}.evt_clear_route_info_h.create_tm is '创建时间';
comment on column ${iml_schema}.evt_clear_route_info_h.modif_tm is '修改时间';
comment on column ${iml_schema}.evt_clear_route_info_h.start_dt is '开始时间';
comment on column ${iml_schema}.evt_clear_route_info_h.end_dt is '结束时间';
comment on column ${iml_schema}.evt_clear_route_info_h.id_mark is '增删标志';
comment on column ${iml_schema}.evt_clear_route_info_h.src_table_name is '源表名称';
comment on column ${iml_schema}.evt_clear_route_info_h.job_cd is '任务编码';
comment on column ${iml_schema}.evt_clear_route_info_h.etl_timestamp is 'ETL处理时间戳';
