/*
Purpose:    整合模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iml agt_check_conf_acct_info
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iml_schema}.agt_check_conf_acct_info
whenever sqlerror continue none;
drop table ${iml_schema}.agt_check_conf_acct_info purge;

whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.agt_check_conf_acct_info(
    agt_id varchar2(250) -- 协议编号
    ,lp_id varchar2(60) -- 法人编号
    ,sign_flow_num varchar2(100) -- 签约流水号
    ,acct_id varchar2(100) -- 账户编号
    ,acct_name varchar2(1500) -- 账户名称
    ,open_acct_dt date -- 开户日期
    ,acct_start_use_dt date -- 账户启用日期
    ,acct_wrtoff_dt date -- 账户注销日期
    ,curr_cd varchar2(60) -- 币种代码
    ,brac_id varchar2(100) -- 网点编号
    ,cotas_name varchar2(750) -- 联系人名称
    ,cotas_addr varchar2(1500) -- 联系人地址
    ,tel_num varchar2(250) -- 电话号码
    ,unite_acct_flg varchar2(30) -- 联合账户标志
    ,oper_teller_id varchar2(100) -- 操作柜员编号
    ,check_teller_id varchar2(100) -- 复核柜员编号
    ,acct_status_cd varchar2(30) -- 账户状态代码
    ,pt_type_cd varchar2(30) -- 支付工具类型代码
    ,acct_type_cd varchar2(30) -- 账户类型代码
    ,long_hang_acct_flg varchar2(10) -- 久悬户标志
    ,main_acct_sign_flow_num varchar2(100) -- 主账户签约流水号
    ,main_acct_acct_id varchar2(100) -- 主账户账户编号
    ,cust_id varchar2(60) -- 客户编号
    ,general_exch_flg_cd varchar2(30) -- 通兑标志代码
    ,start_dt date -- 开始时间
    ,end_dt date -- 结束时间
    ,id_mark varchar2(10) -- 增删标志
    ,src_table_name varchar2(100) -- 源表名称
    ,job_cd varchar2(10) -- 任务编码
    ,etl_timestamp timestamp -- ETL处理时间戳
)
partition by list (job_cd)
subpartition by range (end_dt)
(
   partition p_default values ('default')
   (
        subpartition p_default_19000101 values less than (to_date('20991231','yyyymmdd'))
        ,subpartition p_default_20991231 values less than (maxvalue)
   )
)
storage (initial 1024k next 1024k)
compress ${option_switch} for query high
nologging
;

-- grant
grant select on ${iml_schema}.agt_check_conf_acct_info to ${icl_schema};
grant select on ${iml_schema}.agt_check_conf_acct_info to ${idl_schema};
grant select on ${iml_schema}.agt_check_conf_acct_info to ${iel_schema};

-- comment
comment on table ${iml_schema}.agt_check_conf_acct_info is '验印账户信息';
comment on column ${iml_schema}.agt_check_conf_acct_info.agt_id is '协议编号';
comment on column ${iml_schema}.agt_check_conf_acct_info.lp_id is '法人编号';
comment on column ${iml_schema}.agt_check_conf_acct_info.sign_flow_num is '签约流水号';
comment on column ${iml_schema}.agt_check_conf_acct_info.acct_id is '账户编号';
comment on column ${iml_schema}.agt_check_conf_acct_info.acct_name is '账户名称';
comment on column ${iml_schema}.agt_check_conf_acct_info.open_acct_dt is '开户日期';
comment on column ${iml_schema}.agt_check_conf_acct_info.acct_start_use_dt is '账户启用日期';
comment on column ${iml_schema}.agt_check_conf_acct_info.acct_wrtoff_dt is '账户注销日期';
comment on column ${iml_schema}.agt_check_conf_acct_info.curr_cd is '币种代码';
comment on column ${iml_schema}.agt_check_conf_acct_info.brac_id is '网点编号';
comment on column ${iml_schema}.agt_check_conf_acct_info.cotas_name is '联系人名称';
comment on column ${iml_schema}.agt_check_conf_acct_info.cotas_addr is '联系人地址';
comment on column ${iml_schema}.agt_check_conf_acct_info.tel_num is '电话号码';
comment on column ${iml_schema}.agt_check_conf_acct_info.unite_acct_flg is '联合账户标志';
comment on column ${iml_schema}.agt_check_conf_acct_info.oper_teller_id is '操作柜员编号';
comment on column ${iml_schema}.agt_check_conf_acct_info.check_teller_id is '复核柜员编号';
comment on column ${iml_schema}.agt_check_conf_acct_info.acct_status_cd is '账户状态代码';
comment on column ${iml_schema}.agt_check_conf_acct_info.pt_type_cd is '支付工具类型代码';
comment on column ${iml_schema}.agt_check_conf_acct_info.acct_type_cd is '账户类型代码';
comment on column ${iml_schema}.agt_check_conf_acct_info.long_hang_acct_flg is '久悬户标志';
comment on column ${iml_schema}.agt_check_conf_acct_info.main_acct_sign_flow_num is '主账户签约流水号';
comment on column ${iml_schema}.agt_check_conf_acct_info.main_acct_acct_id is '主账户账户编号';
comment on column ${iml_schema}.agt_check_conf_acct_info.cust_id is '客户编号';
comment on column ${iml_schema}.agt_check_conf_acct_info.general_exch_flg_cd is '通兑标志代码';
comment on column ${iml_schema}.agt_check_conf_acct_info.start_dt is '开始时间';
comment on column ${iml_schema}.agt_check_conf_acct_info.end_dt is '结束时间';
comment on column ${iml_schema}.agt_check_conf_acct_info.id_mark is '增删标志';
comment on column ${iml_schema}.agt_check_conf_acct_info.src_table_name is '源表名称';
comment on column ${iml_schema}.agt_check_conf_acct_info.job_cd is '任务编码';
comment on column ${iml_schema}.agt_check_conf_acct_info.etl_timestamp is 'ETL处理时间戳';
