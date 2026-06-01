/*
Purpose:    整合模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iml agt_payfan_mercht_sign_info_h
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iml_schema}.agt_payfan_mercht_sign_info_h
whenever sqlerror continue none;
drop table ${iml_schema}.agt_payfan_mercht_sign_info_h purge;

whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.agt_payfan_mercht_sign_info_h(
    agt_id varchar2(250) -- 协议编号
    ,lp_id varchar2(100) -- 法人编号
    ,mercht_id varchar2(100) -- 商户编号
    ,mercht_name varchar2(750) -- 商户名称
    ,mercht_abbr varchar2(750) -- 商户简称
    ,white_list_ctrl_flg varchar2(10) -- 白名单控制标志
    ,mercht_status_cd varchar2(30) -- 商户状态代码
    ,supv_acct_id varchar2(100) -- 监管账户编号
    ,supv_acct_name varchar2(750) -- 监管账户名称
    ,supv_acct_open_bank_num varchar2(60) -- 监管账户开户行号
    ,supv_acct_open_bank_name varchar2(750) -- 监管账户开户行名称
    ,supv_acct_type_cd varchar2(30) -- 监管账户类型代码
    ,belong_org_id varchar2(100) -- 所属机构编号
    ,adv_acct_id varchar2(100) -- 垫资账户编号
    ,adv_acct_name varchar2(750) -- 垫资账户名称
    ,adv_acct_open_bank_num varchar2(60) -- 垫资账户开户行号
    ,adv_acct_type_cd varchar2(30) -- 垫资账户类型代码
    ,flow_status_cd varchar2(30) -- 流程状态代码
    ,free_apv_tranbl_acct_flg varchar2(30) -- 免审批可转账标志
    ,create_tm timestamp -- 创建时间
    ,modif_tm timestamp -- 修改时间
    ,matn_teller_id varchar2(100) -- 维护柜员编号
    ,apv_teller_id varchar2(100) -- 审批柜员编号
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
grant select on ${iml_schema}.agt_payfan_mercht_sign_info_h to ${icl_schema};
grant select on ${iml_schema}.agt_payfan_mercht_sign_info_h to ${idl_schema};
grant select on ${iml_schema}.agt_payfan_mercht_sign_info_h to ${iel_schema};

-- comment
comment on table ${iml_schema}.agt_payfan_mercht_sign_info_h is '代付商户签约信息历史';
comment on column ${iml_schema}.agt_payfan_mercht_sign_info_h.agt_id is '协议编号';
comment on column ${iml_schema}.agt_payfan_mercht_sign_info_h.lp_id is '法人编号';
comment on column ${iml_schema}.agt_payfan_mercht_sign_info_h.mercht_id is '商户编号';
comment on column ${iml_schema}.agt_payfan_mercht_sign_info_h.mercht_name is '商户名称';
comment on column ${iml_schema}.agt_payfan_mercht_sign_info_h.mercht_abbr is '商户简称';
comment on column ${iml_schema}.agt_payfan_mercht_sign_info_h.white_list_ctrl_flg is '白名单控制标志';
comment on column ${iml_schema}.agt_payfan_mercht_sign_info_h.mercht_status_cd is '商户状态代码';
comment on column ${iml_schema}.agt_payfan_mercht_sign_info_h.supv_acct_id is '监管账户编号';
comment on column ${iml_schema}.agt_payfan_mercht_sign_info_h.supv_acct_name is '监管账户名称';
comment on column ${iml_schema}.agt_payfan_mercht_sign_info_h.supv_acct_open_bank_num is '监管账户开户行号';
comment on column ${iml_schema}.agt_payfan_mercht_sign_info_h.supv_acct_open_bank_name is '监管账户开户行名称';
comment on column ${iml_schema}.agt_payfan_mercht_sign_info_h.supv_acct_type_cd is '监管账户类型代码';
comment on column ${iml_schema}.agt_payfan_mercht_sign_info_h.belong_org_id is '所属机构编号';
comment on column ${iml_schema}.agt_payfan_mercht_sign_info_h.adv_acct_id is '垫资账户编号';
comment on column ${iml_schema}.agt_payfan_mercht_sign_info_h.adv_acct_name is '垫资账户名称';
comment on column ${iml_schema}.agt_payfan_mercht_sign_info_h.adv_acct_open_bank_num is '垫资账户开户行号';
comment on column ${iml_schema}.agt_payfan_mercht_sign_info_h.adv_acct_type_cd is '垫资账户类型代码';
comment on column ${iml_schema}.agt_payfan_mercht_sign_info_h.flow_status_cd is '流程状态代码';
comment on column ${iml_schema}.agt_payfan_mercht_sign_info_h.free_apv_tranbl_acct_flg is '免审批可转账标志';
comment on column ${iml_schema}.agt_payfan_mercht_sign_info_h.create_tm is '创建时间';
comment on column ${iml_schema}.agt_payfan_mercht_sign_info_h.modif_tm is '修改时间';
comment on column ${iml_schema}.agt_payfan_mercht_sign_info_h.matn_teller_id is '维护柜员编号';
comment on column ${iml_schema}.agt_payfan_mercht_sign_info_h.apv_teller_id is '审批柜员编号';
comment on column ${iml_schema}.agt_payfan_mercht_sign_info_h.start_dt is '开始时间';
comment on column ${iml_schema}.agt_payfan_mercht_sign_info_h.end_dt is '结束时间';
comment on column ${iml_schema}.agt_payfan_mercht_sign_info_h.id_mark is '增删标志';
comment on column ${iml_schema}.agt_payfan_mercht_sign_info_h.src_table_name is '源表名称';
comment on column ${iml_schema}.agt_payfan_mercht_sign_info_h.job_cd is '任务编码';
comment on column ${iml_schema}.agt_payfan_mercht_sign_info_h.etl_timestamp is 'ETL处理时间戳';
