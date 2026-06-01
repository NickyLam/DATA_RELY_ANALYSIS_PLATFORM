/*
Purpose:    整合模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iml agt_cds_precon_subscr_purch_h
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iml_schema}.agt_cds_precon_subscr_purch_h
whenever sqlerror continue none;
drop table ${iml_schema}.agt_cds_precon_subscr_purch_h purge;

whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.agt_cds_precon_subscr_purch_h(
    agt_id varchar2(250) -- 协议编号
    ,seq_num varchar2(60) -- 序号
    ,lp_id varchar2(100) -- 法人编号
    ,cust_id varchar2(100) -- 客户编号
    ,precon_subscr_way_cd varchar2(30) -- 预约认购方式代码
    ,precon_id varchar2(100) -- 预约编号
    ,acct_id varchar2(100) -- 账户编号
    ,lmt_id varchar2(100) -- 限制编号
    ,cert_no varchar2(60) -- 证件号码
    ,cert_type_cd varchar2(30) -- 证件类型代码
    ,cert_cty_rg_cd varchar2(30) -- 发证国家和地区代码
    ,cust_cn_name varchar2(500) -- 客户中文名称
    ,cust_name varchar2(500) -- 客户名称
    ,prod_id varchar2(100) -- 产品编号
    ,pd_prod_precon_status_cd varchar2(30) -- 期次产品预约状态代码
    ,pd_cd varchar2(30) -- 期次编号
    ,pd_prod_cate_cd varchar2(30) -- 期次产品类别代码
    ,issue_termnt_dt date -- 发行终止日期
    ,issue_begin_dt date -- 发行起始日期
    ,open_acct_dt date -- 开户日期
    ,precon_rgst_dt date -- 预约登记日期
    ,precon_open_acct_dt date -- 预约开户日期
    ,aval_amt_cfg_org_id varchar2(100) -- 可用金额配置机构编号
    ,precon_subscr_org_id varchar2(100) -- 预约认购机构编号
    ,tran_ref_no varchar2(60) -- 交易参考号
    ,pd_issue_amt number(30,2) -- 期次发行金额
    ,precon_amt number(30,2) -- 预约金额
    ,curr_cd varchar2(30) -- 币种代码
    ,bank_int_int_rat number(18,8) -- 行内利率
    ,float_int_rat number(18,8) -- 浮动利率
    ,int_rat_adj_way_cd varchar2(30) -- 利率调整方式代码
    ,exec_int_rat number(18,8) -- 执行利率
    ,int_rat_type_cd varchar2(30) -- 利率类型代码
    ,chn_id varchar2(100) -- 渠道编号
    ,del_dt date -- 删除日期
    ,del_rs varchar2(500) -- 删除原因
    ,fail_rs varchar2(500) -- 失败原因
    ,tran_memo_descb varchar2(500) -- 交易摘要描述
    ,auth_teller_id varchar2(100) -- 授权柜员编号
    ,del_auth_teller_id varchar2(100) -- 删除授权柜员编号
    ,del_teller_id varchar2(100) -- 删除柜员编号
    ,tran_tm timestamp -- 交易时间
    ,tran_teller_id varchar2(100) -- 交易柜员编号
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
grant select on ${iml_schema}.agt_cds_precon_subscr_purch_h to ${icl_schema};
grant select on ${iml_schema}.agt_cds_precon_subscr_purch_h to ${idl_schema};
grant select on ${iml_schema}.agt_cds_precon_subscr_purch_h to ${iel_schema};

-- comment
comment on table ${iml_schema}.agt_cds_precon_subscr_purch_h is '大额存单预约认购申购历史';
comment on column ${iml_schema}.agt_cds_precon_subscr_purch_h.agt_id is '协议编号';
comment on column ${iml_schema}.agt_cds_precon_subscr_purch_h.seq_num is '序号';
comment on column ${iml_schema}.agt_cds_precon_subscr_purch_h.lp_id is '法人编号';
comment on column ${iml_schema}.agt_cds_precon_subscr_purch_h.cust_id is '客户编号';
comment on column ${iml_schema}.agt_cds_precon_subscr_purch_h.precon_subscr_way_cd is '预约认购方式代码';
comment on column ${iml_schema}.agt_cds_precon_subscr_purch_h.precon_id is '预约编号';
comment on column ${iml_schema}.agt_cds_precon_subscr_purch_h.acct_id is '账户编号';
comment on column ${iml_schema}.agt_cds_precon_subscr_purch_h.lmt_id is '限制编号';
comment on column ${iml_schema}.agt_cds_precon_subscr_purch_h.cert_no is '证件号码';
comment on column ${iml_schema}.agt_cds_precon_subscr_purch_h.cert_type_cd is '证件类型代码';
comment on column ${iml_schema}.agt_cds_precon_subscr_purch_h.cert_cty_rg_cd is '发证国家和地区代码';
comment on column ${iml_schema}.agt_cds_precon_subscr_purch_h.cust_cn_name is '客户中文名称';
comment on column ${iml_schema}.agt_cds_precon_subscr_purch_h.cust_name is '客户名称';
comment on column ${iml_schema}.agt_cds_precon_subscr_purch_h.prod_id is '产品编号';
comment on column ${iml_schema}.agt_cds_precon_subscr_purch_h.pd_prod_precon_status_cd is '期次产品预约状态代码';
comment on column ${iml_schema}.agt_cds_precon_subscr_purch_h.pd_cd is '期次编号';
comment on column ${iml_schema}.agt_cds_precon_subscr_purch_h.pd_prod_cate_cd is '期次产品类别代码';
comment on column ${iml_schema}.agt_cds_precon_subscr_purch_h.issue_termnt_dt is '发行终止日期';
comment on column ${iml_schema}.agt_cds_precon_subscr_purch_h.issue_begin_dt is '发行起始日期';
comment on column ${iml_schema}.agt_cds_precon_subscr_purch_h.open_acct_dt is '开户日期';
comment on column ${iml_schema}.agt_cds_precon_subscr_purch_h.precon_rgst_dt is '预约登记日期';
comment on column ${iml_schema}.agt_cds_precon_subscr_purch_h.precon_open_acct_dt is '预约开户日期';
comment on column ${iml_schema}.agt_cds_precon_subscr_purch_h.aval_amt_cfg_org_id is '可用金额配置机构编号';
comment on column ${iml_schema}.agt_cds_precon_subscr_purch_h.precon_subscr_org_id is '预约认购机构编号';
comment on column ${iml_schema}.agt_cds_precon_subscr_purch_h.tran_ref_no is '交易参考号';
comment on column ${iml_schema}.agt_cds_precon_subscr_purch_h.pd_issue_amt is '期次发行金额';
comment on column ${iml_schema}.agt_cds_precon_subscr_purch_h.precon_amt is '预约金额';
comment on column ${iml_schema}.agt_cds_precon_subscr_purch_h.curr_cd is '币种代码';
comment on column ${iml_schema}.agt_cds_precon_subscr_purch_h.bank_int_int_rat is '行内利率';
comment on column ${iml_schema}.agt_cds_precon_subscr_purch_h.float_int_rat is '浮动利率';
comment on column ${iml_schema}.agt_cds_precon_subscr_purch_h.int_rat_adj_way_cd is '利率调整方式代码';
comment on column ${iml_schema}.agt_cds_precon_subscr_purch_h.exec_int_rat is '执行利率';
comment on column ${iml_schema}.agt_cds_precon_subscr_purch_h.int_rat_type_cd is '利率类型代码';
comment on column ${iml_schema}.agt_cds_precon_subscr_purch_h.chn_id is '渠道编号';
comment on column ${iml_schema}.agt_cds_precon_subscr_purch_h.del_dt is '删除日期';
comment on column ${iml_schema}.agt_cds_precon_subscr_purch_h.del_rs is '删除原因';
comment on column ${iml_schema}.agt_cds_precon_subscr_purch_h.fail_rs is '失败原因';
comment on column ${iml_schema}.agt_cds_precon_subscr_purch_h.tran_memo_descb is '交易摘要描述';
comment on column ${iml_schema}.agt_cds_precon_subscr_purch_h.auth_teller_id is '授权柜员编号';
comment on column ${iml_schema}.agt_cds_precon_subscr_purch_h.del_auth_teller_id is '删除授权柜员编号';
comment on column ${iml_schema}.agt_cds_precon_subscr_purch_h.del_teller_id is '删除柜员编号';
comment on column ${iml_schema}.agt_cds_precon_subscr_purch_h.tran_tm is '交易时间';
comment on column ${iml_schema}.agt_cds_precon_subscr_purch_h.tran_teller_id is '交易柜员编号';
comment on column ${iml_schema}.agt_cds_precon_subscr_purch_h.start_dt is '开始时间';
comment on column ${iml_schema}.agt_cds_precon_subscr_purch_h.end_dt is '结束时间';
comment on column ${iml_schema}.agt_cds_precon_subscr_purch_h.id_mark is '增删标志';
comment on column ${iml_schema}.agt_cds_precon_subscr_purch_h.src_table_name is '源表名称';
comment on column ${iml_schema}.agt_cds_precon_subscr_purch_h.job_cd is '任务编码';
comment on column ${iml_schema}.agt_cds_precon_subscr_purch_h.etl_timestamp is 'ETL处理时间戳';
