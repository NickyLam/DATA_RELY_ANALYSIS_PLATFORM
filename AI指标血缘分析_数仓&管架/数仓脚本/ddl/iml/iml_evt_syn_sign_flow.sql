/*
Purpose:    整合模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iml evt_syn_sign_flow
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iml_schema}.evt_syn_sign_flow
whenever sqlerror continue none;
drop table ${iml_schema}.evt_syn_sign_flow purge;

whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.evt_syn_sign_flow(
    evt_id varchar2(250) -- 事件编号
    ,lp_id varchar2(60) -- 法人编号
    ,sign_flow_num varchar2(100) -- 签约流水号
    ,chn_cd varchar2(30) -- 渠道代码
    ,chn_flow_num varchar2(100) -- 渠道流水号
    ,trdpty_flow_num varchar2(100) -- 第三方流水号
    ,core_flow_num varchar2(100) -- 核心流水号
    ,tran_type_cd varchar2(30) -- 交易类型代码
    ,cont_id varchar2(100) -- 合约编号
    ,agt_cd varchar2(30) -- 协议代码
    ,cust_id varchar2(100) -- 交易客户编号
    ,acct_id varchar2(100) -- 账户编号
    ,sign_dt date -- 签约日期
    ,sign_tm date -- 签约时间
    ,org_id varchar2(100) -- 机构编号
    ,sign_teller_id varchar2(100) -- 签约柜员编号
    ,auth_teller_id varchar2(100) -- 授权柜员编号
    ,trdpty_sys_tran_code varchar2(45) -- 第三方系统交易码
    ,trdpty_tran_name varchar2(750) -- 第三方交易名称
    ,tran_rest_cd varchar2(30) -- 交易结果代码
    ,vouch_print_flg varchar2(10) -- 凭证打印标志
    ,print_opera_id varchar2(100) -- 打印作业编号
    ,remark varchar2(150) -- 备注
    ,tran_comnt varchar2(4000) -- 交易说明
    ,etl_dt date -- ETL处理日期
    ,src_table_name varchar2(100) -- 源表名称
    ,job_cd varchar2(10) -- 任务编码
    ,etl_timestamp timestamp -- ETL处理时间戳
)
partition by list (job_cd)
subpartition by list (etl_dt)
(
   partition p_default values ('default')
   (
        subpartition p_default_19000101 values (to_date('19000101','yyyymmdd'))
   )
)
storage (initial 1024k next 1024k)
compress ${option_switch} for query high
nologging
;

-- grant
grant select on ${iml_schema}.evt_syn_sign_flow to ${icl_schema};
grant select on ${iml_schema}.evt_syn_sign_flow to ${idl_schema};
grant select on ${iml_schema}.evt_syn_sign_flow to ${iel_schema};

-- comment
comment on table ${iml_schema}.evt_syn_sign_flow is '综合签约流水';
comment on column ${iml_schema}.evt_syn_sign_flow.evt_id is '事件编号';
comment on column ${iml_schema}.evt_syn_sign_flow.lp_id is '法人编号';
comment on column ${iml_schema}.evt_syn_sign_flow.sign_flow_num is '签约流水号';
comment on column ${iml_schema}.evt_syn_sign_flow.chn_cd is '渠道代码';
comment on column ${iml_schema}.evt_syn_sign_flow.chn_flow_num is '渠道流水号';
comment on column ${iml_schema}.evt_syn_sign_flow.trdpty_flow_num is '第三方流水号';
comment on column ${iml_schema}.evt_syn_sign_flow.core_flow_num is '核心流水号';
comment on column ${iml_schema}.evt_syn_sign_flow.tran_type_cd is '交易类型代码';
comment on column ${iml_schema}.evt_syn_sign_flow.cont_id is '合约编号';
comment on column ${iml_schema}.evt_syn_sign_flow.agt_cd is '协议代码';
comment on column ${iml_schema}.evt_syn_sign_flow.cust_id is '交易客户编号';
comment on column ${iml_schema}.evt_syn_sign_flow.acct_id is '账户编号';
comment on column ${iml_schema}.evt_syn_sign_flow.sign_dt is '签约日期';
comment on column ${iml_schema}.evt_syn_sign_flow.sign_tm is '签约时间';
comment on column ${iml_schema}.evt_syn_sign_flow.org_id is '机构编号';
comment on column ${iml_schema}.evt_syn_sign_flow.sign_teller_id is '签约柜员编号';
comment on column ${iml_schema}.evt_syn_sign_flow.auth_teller_id is '授权柜员编号';
comment on column ${iml_schema}.evt_syn_sign_flow.trdpty_sys_tran_code is '第三方系统交易码';
comment on column ${iml_schema}.evt_syn_sign_flow.trdpty_tran_name is '第三方交易名称';
comment on column ${iml_schema}.evt_syn_sign_flow.tran_rest_cd is '交易结果代码';
comment on column ${iml_schema}.evt_syn_sign_flow.vouch_print_flg is '凭证打印标志';
comment on column ${iml_schema}.evt_syn_sign_flow.print_opera_id is '打印作业编号';
comment on column ${iml_schema}.evt_syn_sign_flow.remark is '备注';
comment on column ${iml_schema}.evt_syn_sign_flow.tran_comnt is '交易说明';
comment on column ${iml_schema}.evt_syn_sign_flow.etl_dt is 'ETL处理日期';
comment on column ${iml_schema}.evt_syn_sign_flow.src_table_name is '源表名称';
comment on column ${iml_schema}.evt_syn_sign_flow.job_cd is '任务编码';
comment on column ${iml_schema}.evt_syn_sign_flow.etl_timestamp is 'ETL处理时间戳';
