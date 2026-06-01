/*
Purpose:    整合模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iml ref_dep_vouch_cate_para
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iml_schema}.ref_dep_vouch_cate_para
whenever sqlerror continue none;
drop table ${iml_schema}.ref_dep_vouch_cate_para purge;

whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.ref_dep_vouch_cate_para(
    dep_vouch_cate_cd varchar2(30) -- 存款凭证类别代码
    ,lp_id varchar2(100) -- 法人编号
    ,vouch_type_descb varchar2(500) -- 凭证类型描述
    ,vouch_form_cd varchar2(30) -- 凭证形式代码
    ,vouch_bill_idf_cd varchar2(30) -- 凭证票据标识代码
    ,vouch_id_length number(10) -- 凭证编号长度
    ,have_prefix_flg varchar2(10) -- 有前缀标志
    ,cash_check_flg varchar2(10) -- 现金支票标志
    ,check_flg varchar2(10) -- 支票标志
    ,have_num_flg varchar2(10) -- 有号标志
    ,hq_insto_flg varchar2(10) -- 总行入库标志
    ,lmt_org_use_flg varchar2(10) -- 限制机构使用标志
    ,allow_cannib_flg varchar2(10) -- 允许调拨标志
    ,sell_permit_flg varchar2(10) -- 出售许可标志
    ,mou_hange_days number(10) -- 口挂天数
    ,loss_reissue_days number(10) -- 挂失补发天数
    ,public_agent_mou_hange_days number(10) -- 代办人口挂天数
    ,invalid_dt date -- 失效日期
    ,effect_dt date -- 生效日期
    ,accrd_seq_use_flg varchar2(10) -- 按顺序使用标志
    ,dep_cate_cd varchar2(30) -- 存款类别代码
    ,obank_bill_flg varchar2(10) -- 他行票据标志
    ,apprv_flg varchar2(10) -- 批准标志
    ,have_price_doc_fix_denom_flg varchar2(10) -- 有价单证固定面额标志
    ,have_price_doc_fix_denom_group varchar2(250) -- 有价单证固定面额组
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
grant select on ${iml_schema}.ref_dep_vouch_cate_para to ${icl_schema};
grant select on ${iml_schema}.ref_dep_vouch_cate_para to ${idl_schema};
grant select on ${iml_schema}.ref_dep_vouch_cate_para to ${iel_schema};

-- comment
comment on table ${iml_schema}.ref_dep_vouch_cate_para is '存款凭证类别参数';
comment on column ${iml_schema}.ref_dep_vouch_cate_para.dep_vouch_cate_cd is '存款凭证类别代码';
comment on column ${iml_schema}.ref_dep_vouch_cate_para.lp_id is '法人编号';
comment on column ${iml_schema}.ref_dep_vouch_cate_para.vouch_type_descb is '凭证类型描述';
comment on column ${iml_schema}.ref_dep_vouch_cate_para.vouch_form_cd is '凭证形式代码';
comment on column ${iml_schema}.ref_dep_vouch_cate_para.vouch_bill_idf_cd is '凭证票据标识代码';
comment on column ${iml_schema}.ref_dep_vouch_cate_para.vouch_id_length is '凭证编号长度';
comment on column ${iml_schema}.ref_dep_vouch_cate_para.have_prefix_flg is '有前缀标志';
comment on column ${iml_schema}.ref_dep_vouch_cate_para.cash_check_flg is '现金支票标志';
comment on column ${iml_schema}.ref_dep_vouch_cate_para.check_flg is '支票标志';
comment on column ${iml_schema}.ref_dep_vouch_cate_para.have_num_flg is '有号标志';
comment on column ${iml_schema}.ref_dep_vouch_cate_para.hq_insto_flg is '总行入库标志';
comment on column ${iml_schema}.ref_dep_vouch_cate_para.lmt_org_use_flg is '限制机构使用标志';
comment on column ${iml_schema}.ref_dep_vouch_cate_para.allow_cannib_flg is '允许调拨标志';
comment on column ${iml_schema}.ref_dep_vouch_cate_para.sell_permit_flg is '出售许可标志';
comment on column ${iml_schema}.ref_dep_vouch_cate_para.mou_hange_days is '口挂天数';
comment on column ${iml_schema}.ref_dep_vouch_cate_para.loss_reissue_days is '挂失补发天数';
comment on column ${iml_schema}.ref_dep_vouch_cate_para.public_agent_mou_hange_days is '代办人口挂天数';
comment on column ${iml_schema}.ref_dep_vouch_cate_para.invalid_dt is '失效日期';
comment on column ${iml_schema}.ref_dep_vouch_cate_para.effect_dt is '生效日期';
comment on column ${iml_schema}.ref_dep_vouch_cate_para.accrd_seq_use_flg is '按顺序使用标志';
comment on column ${iml_schema}.ref_dep_vouch_cate_para.dep_cate_cd is '存款类别代码';
comment on column ${iml_schema}.ref_dep_vouch_cate_para.obank_bill_flg is '他行票据标志';
comment on column ${iml_schema}.ref_dep_vouch_cate_para.apprv_flg is '批准标志';
comment on column ${iml_schema}.ref_dep_vouch_cate_para.have_price_doc_fix_denom_flg is '有价单证固定面额标志';
comment on column ${iml_schema}.ref_dep_vouch_cate_para.have_price_doc_fix_denom_group is '有价单证固定面额组';
comment on column ${iml_schema}.ref_dep_vouch_cate_para.start_dt is '开始时间';
comment on column ${iml_schema}.ref_dep_vouch_cate_para.end_dt is '结束时间';
comment on column ${iml_schema}.ref_dep_vouch_cate_para.id_mark is '增删标志';
comment on column ${iml_schema}.ref_dep_vouch_cate_para.src_table_name is '源表名称';
comment on column ${iml_schema}.ref_dep_vouch_cate_para.job_cd is '任务编码';
comment on column ${iml_schema}.ref_dep_vouch_cate_para.etl_timestamp is 'ETL处理时间戳';
