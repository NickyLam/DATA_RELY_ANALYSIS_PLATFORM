/*
Purpose:    应用集市层-建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py itl itl_edw_evt_core_basic_tran
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${itl_schema}.itl_edw_evt_core_basic_tran
whenever sqlerror continue none;
drop table ${itl_schema}.itl_edw_evt_core_basic_tran purge;

whenever sqlerror exit sql.sqlcode;
create table ${itl_schema}.itl_edw_evt_core_basic_tran(
    etl_dt date -- 数据日期
    ,evt_id varchar2(60) -- 事件编号
    ,lp_id varchar2(60) -- 法人编号
    ,tran_dt date -- 交易日期
    ,tran_flow_num varchar2(60) -- 交易流水号
    ,tran_tm timestamp -- 交易时间
    ,tran_kind_cd varchar2(10) -- 交易种类代码
    ,tran_code varchar2(30) -- 交易码
    ,tran_chn_id varchar2(60) -- 交易渠道编号
    ,tran_org_id varchar2(60) -- 交易机构编号
    ,termn_id varchar2(60) -- 终端编号
    ,tran_teller_id varchar2(60) -- 交易柜员编号
    ,check_teller_id varchar2(60) -- 复核柜员编号
    ,auth_teller_id varchar2(60) -- 授权柜员编号
    ,bal_chk_flg varchar2(10) -- 勾对标志
    ,tran_status_cd varchar2(10) -- 交易状态代码
    ,ova_flow_num varchar2(100) -- 全局流水号
    ,ext_flow_num varchar2(100) -- 外部流水号
    ,cnter_tran_code varchar2(30) -- 柜面交易码
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
grant select on ${itl_schema}.itl_edw_evt_core_basic_tran to ${iel_schema};

-- comment
comment on table ${itl_schema}.itl_edw_evt_core_basic_tran is '核心基本交易';
comment on column ${itl_schema}.itl_edw_evt_core_basic_tran.etl_dt is '数据日期';
comment on column ${itl_schema}.itl_edw_evt_core_basic_tran.evt_id is '事件编号';
comment on column ${itl_schema}.itl_edw_evt_core_basic_tran.lp_id is '法人编号';
comment on column ${itl_schema}.itl_edw_evt_core_basic_tran.tran_dt is '交易日期';
comment on column ${itl_schema}.itl_edw_evt_core_basic_tran.tran_flow_num is '交易流水号';
comment on column ${itl_schema}.itl_edw_evt_core_basic_tran.tran_tm is '交易时间';
comment on column ${itl_schema}.itl_edw_evt_core_basic_tran.tran_kind_cd is '交易种类代码';
comment on column ${itl_schema}.itl_edw_evt_core_basic_tran.tran_code is '交易码';
comment on column ${itl_schema}.itl_edw_evt_core_basic_tran.tran_chn_id is '交易渠道编号';
comment on column ${itl_schema}.itl_edw_evt_core_basic_tran.tran_org_id is '交易机构编号';
comment on column ${itl_schema}.itl_edw_evt_core_basic_tran.termn_id is '终端编号';
comment on column ${itl_schema}.itl_edw_evt_core_basic_tran.tran_teller_id is '交易柜员编号';
comment on column ${itl_schema}.itl_edw_evt_core_basic_tran.check_teller_id is '复核柜员编号';
comment on column ${itl_schema}.itl_edw_evt_core_basic_tran.auth_teller_id is '授权柜员编号';
comment on column ${itl_schema}.itl_edw_evt_core_basic_tran.bal_chk_flg is '勾对标志';
comment on column ${itl_schema}.itl_edw_evt_core_basic_tran.tran_status_cd is '交易状态代码';
comment on column ${itl_schema}.itl_edw_evt_core_basic_tran.ova_flow_num is '全局流水号';
comment on column ${itl_schema}.itl_edw_evt_core_basic_tran.ext_flow_num is '外部流水号';
comment on column ${itl_schema}.itl_edw_evt_core_basic_tran.cnter_tran_code is '柜面交易码';
comment on column ${itl_schema}.itl_edw_evt_core_basic_tran.etl_timestamp is 'ETL处理时间戳';