/*
Purpose:    整合模型层-快照表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iml agt_ifs_sub_acct
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iml_schema}.agt_ifs_sub_acct
whenever sqlerror continue none;
drop table ${iml_schema}.agt_ifs_sub_acct purge;

whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.agt_ifs_sub_acct(
    agt_id varchar2(60) -- 协议编号
    ,lp_id varchar2(60) -- 法人编号
    ,dep_prod_sub_acct_id varchar2(60) -- 存款产品分户编号
    ,dep_acct_id varchar2(60) -- 存款账户编号
    ,acct_name varchar2(150) -- 账户名称
    ,cust_id varchar2(60) -- 客户编号
    ,prod_id varchar2(60) -- 产品编号
    ,ext_prod_id varchar2(100) -- 外部产品编号
    ,dep_acct_status_cd varchar2(10) -- 存款账户状态代码
    ,acpt_pay_flg_cd varchar2(10) -- 收付标志代码
    ,froz_status_cd varchar2(10) -- 冻结状态代码
    ,stop_pay_status_cd varchar2(10) -- 止付状态代码
    ,int_accr_flg varchar2(10) -- 计息标志
    ,open_acct_dt date -- 开户日期
    ,value_dt date -- 起息日期
    ,exp_dt date -- 到期日期
    ,pric_amt number(30,2) -- 本金金额
    ,froz_amt number(30,2) -- 冻结金额
    ,stop_pay_amt number(30,2) -- 止付金额
    ,acct_instit_id varchar2(60) -- 账务机构编号
    ,open_acct_org_id varchar2(60) -- 开户机构编号
    ,open_acct_chn_cd varchar2(10) -- 开户渠道代码
    ,open_acct_flow_num varchar2(60) -- 开户流水号
    ,last_activ_acct_dt date -- 上次动户日期
    ,exec_int_rat number(18,8) -- 执行利率
    ,base_rat number(18,8) -- 基准利率
    ,flo_val number(18,8) -- 浮动值
    ,clos_acct_dt date -- 销户日期
    ,clos_acct_flow_num varchar2(60) -- 销户流水号
    ,pa_ext_cnt number(10) -- 部提次数
    ,dep_term_cd varchar2(10) -- 存期代码
    ,dep_tenor varchar2(15) -- 存款期限
    ,adu_bk_acct_dt date -- 对接行的账务日期
    ,open_acct_tm timestamp -- 开户时间
    ,clos_acct_tm timestamp -- 销户时间
    ,fee_dt date -- 费用日期
    ,webank_card_no varchar2(100) -- 微众银行卡号
    ,sav_type_cd varchar2(30) -- 储种代码
    ,create_dt date -- 创建日期
    ,update_dt date -- 更新日期
    ,etl_dt date -- ETL处理日期
    ,id_mark varchar2(10) -- 增删标志
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
grant select on ${iml_schema}.agt_ifs_sub_acct to ${icl_schema};
grant select on ${iml_schema}.agt_ifs_sub_acct to ${idl_schema};
grant select on ${iml_schema}.agt_ifs_sub_acct to ${iel_schema};

-- comment
comment on table ${iml_schema}.agt_ifs_sub_acct is '联合存款分户';
comment on column ${iml_schema}.agt_ifs_sub_acct.agt_id is '协议编号';
comment on column ${iml_schema}.agt_ifs_sub_acct.lp_id is '法人编号';
comment on column ${iml_schema}.agt_ifs_sub_acct.dep_prod_sub_acct_id is '存款产品分户编号';
comment on column ${iml_schema}.agt_ifs_sub_acct.dep_acct_id is '存款账户编号';
comment on column ${iml_schema}.agt_ifs_sub_acct.acct_name is '账户名称';
comment on column ${iml_schema}.agt_ifs_sub_acct.cust_id is '客户编号';
comment on column ${iml_schema}.agt_ifs_sub_acct.prod_id is '产品编号';
comment on column ${iml_schema}.agt_ifs_sub_acct.ext_prod_id is '外部产品编号';
comment on column ${iml_schema}.agt_ifs_sub_acct.dep_acct_status_cd is '存款账户状态代码';
comment on column ${iml_schema}.agt_ifs_sub_acct.acpt_pay_flg_cd is '收付标志代码';
comment on column ${iml_schema}.agt_ifs_sub_acct.froz_status_cd is '冻结状态代码';
comment on column ${iml_schema}.agt_ifs_sub_acct.stop_pay_status_cd is '止付状态代码';
comment on column ${iml_schema}.agt_ifs_sub_acct.int_accr_flg is '计息标志';
comment on column ${iml_schema}.agt_ifs_sub_acct.open_acct_dt is '开户日期';
comment on column ${iml_schema}.agt_ifs_sub_acct.value_dt is '起息日期';
comment on column ${iml_schema}.agt_ifs_sub_acct.exp_dt is '到期日期';
comment on column ${iml_schema}.agt_ifs_sub_acct.pric_amt is '本金金额';
comment on column ${iml_schema}.agt_ifs_sub_acct.froz_amt is '冻结金额';
comment on column ${iml_schema}.agt_ifs_sub_acct.stop_pay_amt is '止付金额';
comment on column ${iml_schema}.agt_ifs_sub_acct.acct_instit_id is '账务机构编号';
comment on column ${iml_schema}.agt_ifs_sub_acct.open_acct_org_id is '开户机构编号';
comment on column ${iml_schema}.agt_ifs_sub_acct.open_acct_chn_cd is '开户渠道代码';
comment on column ${iml_schema}.agt_ifs_sub_acct.open_acct_flow_num is '开户流水号';
comment on column ${iml_schema}.agt_ifs_sub_acct.last_activ_acct_dt is '上次动户日期';
comment on column ${iml_schema}.agt_ifs_sub_acct.exec_int_rat is '执行利率';
comment on column ${iml_schema}.agt_ifs_sub_acct.base_rat is '基准利率';
comment on column ${iml_schema}.agt_ifs_sub_acct.flo_val is '浮动值';
comment on column ${iml_schema}.agt_ifs_sub_acct.clos_acct_dt is '销户日期';
comment on column ${iml_schema}.agt_ifs_sub_acct.clos_acct_flow_num is '销户流水号';
comment on column ${iml_schema}.agt_ifs_sub_acct.pa_ext_cnt is '部提次数';
comment on column ${iml_schema}.agt_ifs_sub_acct.dep_term_cd is '存期代码';
comment on column ${iml_schema}.agt_ifs_sub_acct.dep_tenor is '存款期限';
comment on column ${iml_schema}.agt_ifs_sub_acct.adu_bk_acct_dt is '对接行的账务日期';
comment on column ${iml_schema}.agt_ifs_sub_acct.open_acct_tm is '开户时间';
comment on column ${iml_schema}.agt_ifs_sub_acct.clos_acct_tm is '销户时间';
comment on column ${iml_schema}.agt_ifs_sub_acct.fee_dt is '费用日期';
comment on column ${iml_schema}.agt_ifs_sub_acct.webank_card_no is '微众银行卡号';
comment on column ${iml_schema}.agt_ifs_sub_acct.sav_type_cd is '储种代码';
comment on column ${iml_schema}.agt_ifs_sub_acct.create_dt is '创建日期';
comment on column ${iml_schema}.agt_ifs_sub_acct.update_dt is '更新日期';
comment on column ${iml_schema}.agt_ifs_sub_acct.etl_dt is 'ETL处理日期';
comment on column ${iml_schema}.agt_ifs_sub_acct.id_mark is '增删标志';
comment on column ${iml_schema}.agt_ifs_sub_acct.src_table_name is '源表名称';
comment on column ${iml_schema}.agt_ifs_sub_acct.job_cd is '任务编码';
comment on column ${iml_schema}.agt_ifs_sub_acct.etl_timestamp is 'ETL处理时间戳';
