/*
Purpose:    整合模型层-切片建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iml agt_wyd_guar_cont_h
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iml_schema}.agt_wyd_guar_cont_h
whenever sqlerror continue none;
drop table ${iml_schema}.agt_wyd_guar_cont_h purge;

whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.agt_wyd_guar_cont_h(
    agt_id varchar2(250) -- 协议编号
    ,lp_id varchar2(100) -- 法人编号
    ,guar_cont_id varchar2(100) -- 担保合同编号
    ,prod_id varchar2(100) -- 产品编号
    ,level5_cls_cd varchar2(30) -- 五级分类代码
    ,curr_cd varchar2(30) -- 币种代码
    ,pri_contr_type_cd varchar2(30) -- 主合同类型代码
    ,guar_amt number(30,8) -- 担保金额
    ,effect_flg varchar2(10) -- 生效标志
    ,sign_dt date -- 签约日期
    ,exp_dt date -- 到期日期
    ,guar_cont_type_cd varchar2(30) -- 担保合同类型代码
    ,cust_id varchar2(100) -- 客户编号
    ,guartor_cust_id varchar2(100) -- 担保人客户编号
    ,guartor_cust_name varchar2(500) -- 担保人客户名称
    ,guartor_cust_type_cd varchar2(60) -- 担保人客户类型代码
    ,guartor_cert_type_cd varchar2(30) -- 担保人证件类型代码
    ,guartor_cert_no varchar2(100) -- 担保人证件号码
    ,guar_form_cd varchar2(30) -- 担保形式代码
    ,guar_way_cd varchar2(30) -- 担保方式代码
    ,lmt_id varchar2(100) -- 额度编号
    ,plat_batch_guar_flg varchar2(10) -- 平台批量担保标志
    ,gov_guar_cate_cd varchar2(30) -- 政府融资担保类别代码
    ,oper_teller_id varchar2(100) -- 经办柜员编号
    ,rgst_teller_id varchar2(100) -- 登记柜员编号
    ,rgst_org_id varchar2(100) -- 登记机构编号
    ,rgst_dt date -- 登记日期
    ,final_update_teller_id varchar2(100) -- 最后更新柜员编号
    ,final_update_org_id varchar2(100) -- 最后更新机构编号
    ,final_update_dt date -- 最后更新日期
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
grant select on ${iml_schema}.agt_wyd_guar_cont_h to ${icl_schema};
grant select on ${iml_schema}.agt_wyd_guar_cont_h to ${idl_schema};
grant select on ${iml_schema}.agt_wyd_guar_cont_h to ${iel_schema};

-- comment
comment on table ${iml_schema}.agt_wyd_guar_cont_h is '微业贷担保合同信息历史';
comment on column ${iml_schema}.agt_wyd_guar_cont_h.agt_id is '协议编号';
comment on column ${iml_schema}.agt_wyd_guar_cont_h.lp_id is '法人编号';
comment on column ${iml_schema}.agt_wyd_guar_cont_h.guar_cont_id is '担保合同编号';
comment on column ${iml_schema}.agt_wyd_guar_cont_h.prod_id is '产品编号';
comment on column ${iml_schema}.agt_wyd_guar_cont_h.level5_cls_cd is '五级分类代码';
comment on column ${iml_schema}.agt_wyd_guar_cont_h.curr_cd is '币种代码';
comment on column ${iml_schema}.agt_wyd_guar_cont_h.pri_contr_type_cd is '主合同类型代码';
comment on column ${iml_schema}.agt_wyd_guar_cont_h.guar_amt is '担保金额';
comment on column ${iml_schema}.agt_wyd_guar_cont_h.effect_flg is '生效标志';
comment on column ${iml_schema}.agt_wyd_guar_cont_h.sign_dt is '签约日期';
comment on column ${iml_schema}.agt_wyd_guar_cont_h.exp_dt is '到期日期';
comment on column ${iml_schema}.agt_wyd_guar_cont_h.guar_cont_type_cd is '担保合同类型代码';
comment on column ${iml_schema}.agt_wyd_guar_cont_h.cust_id is '客户编号';
comment on column ${iml_schema}.agt_wyd_guar_cont_h.guartor_cust_id is '担保人客户编号';
comment on column ${iml_schema}.agt_wyd_guar_cont_h.guartor_cust_name is '担保人客户名称';
comment on column ${iml_schema}.agt_wyd_guar_cont_h.guartor_cust_type_cd is '担保人客户类型代码';
comment on column ${iml_schema}.agt_wyd_guar_cont_h.guartor_cert_type_cd is '担保人证件类型代码';
comment on column ${iml_schema}.agt_wyd_guar_cont_h.guartor_cert_no is '担保人证件号码';
comment on column ${iml_schema}.agt_wyd_guar_cont_h.guar_form_cd is '担保形式代码';
comment on column ${iml_schema}.agt_wyd_guar_cont_h.guar_way_cd is '担保方式代码';
comment on column ${iml_schema}.agt_wyd_guar_cont_h.lmt_id is '额度编号';
comment on column ${iml_schema}.agt_wyd_guar_cont_h.plat_batch_guar_flg is '平台批量担保标志';
comment on column ${iml_schema}.agt_wyd_guar_cont_h.gov_guar_cate_cd is '政府融资担保类别代码';
comment on column ${iml_schema}.agt_wyd_guar_cont_h.oper_teller_id is '经办柜员编号';
comment on column ${iml_schema}.agt_wyd_guar_cont_h.rgst_teller_id is '登记柜员编号';
comment on column ${iml_schema}.agt_wyd_guar_cont_h.rgst_org_id is '登记机构编号';
comment on column ${iml_schema}.agt_wyd_guar_cont_h.rgst_dt is '登记日期';
comment on column ${iml_schema}.agt_wyd_guar_cont_h.final_update_teller_id is '最后更新柜员编号';
comment on column ${iml_schema}.agt_wyd_guar_cont_h.final_update_org_id is '最后更新机构编号';
comment on column ${iml_schema}.agt_wyd_guar_cont_h.final_update_dt is '最后更新日期';
comment on column ${iml_schema}.agt_wyd_guar_cont_h.etl_dt is 'ETL处理日期';
comment on column ${iml_schema}.agt_wyd_guar_cont_h.src_table_name is '源表名称';
comment on column ${iml_schema}.agt_wyd_guar_cont_h.job_cd is '任务编码';
comment on column ${iml_schema}.agt_wyd_guar_cont_h.etl_timestamp is 'ETL处理时间戳';
