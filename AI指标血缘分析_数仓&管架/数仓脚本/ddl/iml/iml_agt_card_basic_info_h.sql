/*
Purpose:    整合模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iml agt_card_basic_info_h
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iml_schema}.agt_card_basic_info_h
whenever sqlerror continue none;
drop table ${iml_schema}.agt_card_basic_info_h purge;

whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.agt_card_basic_info_h(
    vouch_id varchar2(250) -- 凭证编号
    ,lp_id varchar2(100) -- 法人编号
    ,card_no varchar2(60) -- 卡号
    ,cust_id varchar2(100) -- 客户编号
    ,card_iss_dt date -- 发卡日期
    ,card_iss_teller_id varchar2(100) -- 发卡柜员编号
    ,bank_card_status_cd varchar2(30) -- 银行卡状态代码
    ,change_card_cnt number(10) -- 换卡次数
    ,main_card_card_no varchar2(60) -- 主卡卡号
    ,card_prod_id varchar2(100) -- 卡产品编号
    ,sub_acct_num varchar2(60) -- 子账号
    ,pin_card_rs varchar2(500) -- 销卡原因
    ,pin_card_dt date -- 销卡日期
    ,effect_dt date -- 生效日期
    ,invalid_dt date -- 失效日期
    ,pin_card_teller_id varchar2(100) -- 销卡柜员编号
    ,card_iss_org_id varchar2(100) -- 发卡机构编号
    ,card_med_type_cd varchar2(30) -- 卡介质类型代码
    ,appl_id varchar2(100) -- 申请编号
    ,supp_card_flg varchar2(10) -- 附属卡标志
    ,stl_card_flg varchar2(10) -- 单位结算卡标志
    ,card_psbook_merge_flg varchar2(10) -- 卡折合一标志
    ,nomi_card_flg varchar2(10) -- 记名卡标志
    ,make_card_doc_batch_no varchar2(60) -- 制卡文件批次号
    ,card_cvn_info varchar2(500) -- 卡片CVN信息
    ,accu_fail_cnt number(10) -- 累积失败次数
    ,appl_teller_id varchar2(250) -- 申请柜员编号
    ,last_modif_dt date -- 上次修改日期
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
grant select on ${iml_schema}.agt_card_basic_info_h to ${icl_schema};
grant select on ${iml_schema}.agt_card_basic_info_h to ${idl_schema};
grant select on ${iml_schema}.agt_card_basic_info_h to ${iel_schema};

-- comment
comment on table ${iml_schema}.agt_card_basic_info_h is '卡片基本信息历史';
comment on column ${iml_schema}.agt_card_basic_info_h.vouch_id is '凭证编号';
comment on column ${iml_schema}.agt_card_basic_info_h.lp_id is '法人编号';
comment on column ${iml_schema}.agt_card_basic_info_h.card_no is '卡号';
comment on column ${iml_schema}.agt_card_basic_info_h.cust_id is '客户编号';
comment on column ${iml_schema}.agt_card_basic_info_h.card_iss_dt is '发卡日期';
comment on column ${iml_schema}.agt_card_basic_info_h.card_iss_teller_id is '发卡柜员编号';
comment on column ${iml_schema}.agt_card_basic_info_h.bank_card_status_cd is '银行卡状态代码';
comment on column ${iml_schema}.agt_card_basic_info_h.change_card_cnt is '换卡次数';
comment on column ${iml_schema}.agt_card_basic_info_h.main_card_card_no is '主卡卡号';
comment on column ${iml_schema}.agt_card_basic_info_h.card_prod_id is '卡产品编号';
comment on column ${iml_schema}.agt_card_basic_info_h.sub_acct_num is '子账号';
comment on column ${iml_schema}.agt_card_basic_info_h.pin_card_rs is '销卡原因';
comment on column ${iml_schema}.agt_card_basic_info_h.pin_card_dt is '销卡日期';
comment on column ${iml_schema}.agt_card_basic_info_h.effect_dt is '生效日期';
comment on column ${iml_schema}.agt_card_basic_info_h.invalid_dt is '失效日期';
comment on column ${iml_schema}.agt_card_basic_info_h.pin_card_teller_id is '销卡柜员编号';
comment on column ${iml_schema}.agt_card_basic_info_h.card_iss_org_id is '发卡机构编号';
comment on column ${iml_schema}.agt_card_basic_info_h.card_med_type_cd is '卡介质类型代码';
comment on column ${iml_schema}.agt_card_basic_info_h.appl_id is '申请编号';
comment on column ${iml_schema}.agt_card_basic_info_h.supp_card_flg is '附属卡标志';
comment on column ${iml_schema}.agt_card_basic_info_h.stl_card_flg is '单位结算卡标志';
comment on column ${iml_schema}.agt_card_basic_info_h.card_psbook_merge_flg is '卡折合一标志';
comment on column ${iml_schema}.agt_card_basic_info_h.nomi_card_flg is '记名卡标志';
comment on column ${iml_schema}.agt_card_basic_info_h.make_card_doc_batch_no is '制卡文件批次号';
comment on column ${iml_schema}.agt_card_basic_info_h.card_cvn_info is '卡片CVN信息';
comment on column ${iml_schema}.agt_card_basic_info_h.accu_fail_cnt is '累积失败次数';
comment on column ${iml_schema}.agt_card_basic_info_h.appl_teller_id is '申请柜员编号';
comment on column ${iml_schema}.agt_card_basic_info_h.last_modif_dt is '上次修改日期';
comment on column ${iml_schema}.agt_card_basic_info_h.start_dt is '开始时间';
comment on column ${iml_schema}.agt_card_basic_info_h.end_dt is '结束时间';
comment on column ${iml_schema}.agt_card_basic_info_h.id_mark is '增删标志';
comment on column ${iml_schema}.agt_card_basic_info_h.src_table_name is '源表名称';
comment on column ${iml_schema}.agt_card_basic_info_h.job_cd is '任务编码';
comment on column ${iml_schema}.agt_card_basic_info_h.etl_timestamp is 'ETL处理时间戳';
