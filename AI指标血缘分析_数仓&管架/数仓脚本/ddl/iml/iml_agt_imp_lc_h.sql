/*
Purpose:    整合模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iml agt_imp_lc_h
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iml_schema}.agt_imp_lc_h
whenever sqlerror continue none;
drop table ${iml_schema}.agt_imp_lc_h purge;

whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.agt_imp_lc_h(
    agt_id varchar2(250) -- 协议编号
    ,lp_id varchar2(60) -- 法人编号
    ,intnal_lc_id varchar2(100) -- 内部信用证编号
    ,lc_id varchar2(100) -- 信用证编号
    ,tran_name varchar2(750) -- 交易名称
    ,teller_id varchar2(100) -- 柜员编号
    ,lc_effect_dt date -- 信用证生效日期
    ,lc_issue_dt date -- 信用证开证日期
    ,lc_invalid_dt date -- 信用证失效日期
    ,advise_bank_name varchar2(750) -- 通知行名称
    ,advise_bank_ref_id varchar2(100) -- 通知行参考编号
    ,final_modif_dt date -- 最后修改日期
    ,applit_name varchar2(750) -- 申请人名称
    ,pay_way_cd varchar2(30) -- 付款方式代码
    ,benefc_name varchar2(750) -- 受益人名称
    ,fee_src_cd varchar2(30) -- 费用来源代码
    ,cfm_way_cd varchar2(30) -- 保兑方式代码
    ,lc_valid_dt date -- 信用证有效日期
    ,present_site varchar2(150) -- 交单地点
    ,lc_type_cd varchar2(30) -- 信用证类型代码
    ,pre_advise_dt date -- 预通知日期
    ,pay_back_flg varchar2(30) -- 偿付标志
    ,red_green_claus_flg varchar2(30) -- 红绿条款标志
    ,backtb_lc_flg varchar2(30) -- 背对背信用证标志
    ,backtb_lc_id varchar2(100) -- 背对背信用证编号
    ,fwd_tenor number(10) -- 远期期限
    ,belong_org_id varchar2(100) -- 所属机构编号
    ,tran_org_id varchar2(100) -- 交易机构编号
    ,margin_recvbl_ratio number(18,6) -- 保证金应收比例
    ,issue_way_cd varchar2(30) -- 开证方式代码
    ,dubil_id varchar2(100) -- 借据编号
    ,inpwn_type_cd varchar2(30) -- 质押类型代码
    ,margin_actl_recv_ratio number(18,6) -- 保证金实收比例
    ,dom_lc_flg varchar2(30) -- 国内信用证标志
    ,lc_bal number(30,6) -- 信用证余额
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
grant select on ${iml_schema}.agt_imp_lc_h to ${icl_schema};
grant select on ${iml_schema}.agt_imp_lc_h to ${idl_schema};
grant select on ${iml_schema}.agt_imp_lc_h to ${iel_schema};

-- comment
comment on table ${iml_schema}.agt_imp_lc_h is '进口信用证历史';
comment on column ${iml_schema}.agt_imp_lc_h.agt_id is '协议编号';
comment on column ${iml_schema}.agt_imp_lc_h.lp_id is '法人编号';
comment on column ${iml_schema}.agt_imp_lc_h.intnal_lc_id is '内部信用证编号';
comment on column ${iml_schema}.agt_imp_lc_h.lc_id is '信用证编号';
comment on column ${iml_schema}.agt_imp_lc_h.tran_name is '交易名称';
comment on column ${iml_schema}.agt_imp_lc_h.teller_id is '柜员编号';
comment on column ${iml_schema}.agt_imp_lc_h.lc_effect_dt is '信用证生效日期';
comment on column ${iml_schema}.agt_imp_lc_h.lc_issue_dt is '信用证开证日期';
comment on column ${iml_schema}.agt_imp_lc_h.lc_invalid_dt is '信用证失效日期';
comment on column ${iml_schema}.agt_imp_lc_h.advise_bank_name is '通知行名称';
comment on column ${iml_schema}.agt_imp_lc_h.advise_bank_ref_id is '通知行参考编号';
comment on column ${iml_schema}.agt_imp_lc_h.final_modif_dt is '最后修改日期';
comment on column ${iml_schema}.agt_imp_lc_h.applit_name is '申请人名称';
comment on column ${iml_schema}.agt_imp_lc_h.pay_way_cd is '付款方式代码';
comment on column ${iml_schema}.agt_imp_lc_h.benefc_name is '受益人名称';
comment on column ${iml_schema}.agt_imp_lc_h.fee_src_cd is '费用来源代码';
comment on column ${iml_schema}.agt_imp_lc_h.cfm_way_cd is '保兑方式代码';
comment on column ${iml_schema}.agt_imp_lc_h.lc_valid_dt is '信用证有效日期';
comment on column ${iml_schema}.agt_imp_lc_h.present_site is '交单地点';
comment on column ${iml_schema}.agt_imp_lc_h.lc_type_cd is '信用证类型代码';
comment on column ${iml_schema}.agt_imp_lc_h.pre_advise_dt is '预通知日期';
comment on column ${iml_schema}.agt_imp_lc_h.pay_back_flg is '偿付标志';
comment on column ${iml_schema}.agt_imp_lc_h.red_green_claus_flg is '红绿条款标志';
comment on column ${iml_schema}.agt_imp_lc_h.backtb_lc_flg is '背对背信用证标志';
comment on column ${iml_schema}.agt_imp_lc_h.backtb_lc_id is '背对背信用证编号';
comment on column ${iml_schema}.agt_imp_lc_h.fwd_tenor is '远期期限';
comment on column ${iml_schema}.agt_imp_lc_h.belong_org_id is '所属机构编号';
comment on column ${iml_schema}.agt_imp_lc_h.tran_org_id is '交易机构编号';
comment on column ${iml_schema}.agt_imp_lc_h.margin_recvbl_ratio is '保证金应收比例';
comment on column ${iml_schema}.agt_imp_lc_h.issue_way_cd is '开证方式代码';
comment on column ${iml_schema}.agt_imp_lc_h.dubil_id is '借据编号';
comment on column ${iml_schema}.agt_imp_lc_h.inpwn_type_cd is '质押类型代码';
comment on column ${iml_schema}.agt_imp_lc_h.margin_actl_recv_ratio is '保证金实收比例';
comment on column ${iml_schema}.agt_imp_lc_h.dom_lc_flg is '国内信用证标志';
comment on column ${iml_schema}.agt_imp_lc_h.lc_bal is '信用证余额';
comment on column ${iml_schema}.agt_imp_lc_h.start_dt is '开始时间';
comment on column ${iml_schema}.agt_imp_lc_h.end_dt is '结束时间';
comment on column ${iml_schema}.agt_imp_lc_h.id_mark is '增删标志';
comment on column ${iml_schema}.agt_imp_lc_h.src_table_name is '源表名称';
comment on column ${iml_schema}.agt_imp_lc_h.job_cd is '任务编码';
comment on column ${iml_schema}.agt_imp_lc_h.etl_timestamp is 'ETL处理时间戳';
