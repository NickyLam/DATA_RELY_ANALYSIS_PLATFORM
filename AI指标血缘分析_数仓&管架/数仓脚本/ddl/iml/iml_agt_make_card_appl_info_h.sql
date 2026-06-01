/*
Purpose:    整合模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iml agt_make_card_appl_info_h
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iml_schema}.agt_make_card_appl_info_h
whenever sqlerror continue none;
drop table ${iml_schema}.agt_make_card_appl_info_h purge;

whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.agt_make_card_appl_info_h(
    agt_id varchar2(250) -- 协议编号
    ,lp_id varchar2(100) -- 法人编号
    ,appl_id varchar2(100) -- 申请编号
    ,appl_dt date -- 申请日期
    ,card_prod_id varchar2(100) -- 卡产品编号
    ,card_corp_abbr varchar2(100) -- 卡商简称
    ,make_card_dt date -- 制卡日期
    ,make_card_type_cd varchar2(30) -- 制卡类型代码
    ,make_card_appl_type_cd varchar2(30) -- 制卡申请类型代码
    ,make_card_qtty number(30) -- 制卡数量
    ,make_card_status_cd varchar2(30) -- 制卡状态代码
    ,make_card_doc_batch_no varchar2(60) -- 制卡文件批次号
    ,pre_make_card_cty_rg_cd varchar2(30) -- 预制卡国家和地区代码
    ,lucky_card_flg varchar2(10) -- 吉祥卡标志
    ,tran_teller_id varchar2(100) -- 交易柜员编号
    ,tran_org_id varchar2(100) -- 交易机构编号
    ,tran_tm timestamp -- 交易时间
    ,choice_num_type_cd varchar2(30) -- 选号类型代码
    ,card_draw_way_cd varchar2(30) -- 卡片领取方式代码
    ,recv_flg varchar2(10) -- 签收标志
    ,dep_vouch_cate_cd varchar2(30) -- 存款凭证类别代码
    ,remark varchar2(500) -- 备注
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
grant select on ${iml_schema}.agt_make_card_appl_info_h to ${icl_schema};
grant select on ${iml_schema}.agt_make_card_appl_info_h to ${idl_schema};
grant select on ${iml_schema}.agt_make_card_appl_info_h to ${iel_schema};

-- comment
comment on table ${iml_schema}.agt_make_card_appl_info_h is '制卡申请信息历史';
comment on column ${iml_schema}.agt_make_card_appl_info_h.agt_id is '协议编号';
comment on column ${iml_schema}.agt_make_card_appl_info_h.lp_id is '法人编号';
comment on column ${iml_schema}.agt_make_card_appl_info_h.appl_id is '申请编号';
comment on column ${iml_schema}.agt_make_card_appl_info_h.appl_dt is '申请日期';
comment on column ${iml_schema}.agt_make_card_appl_info_h.card_prod_id is '卡产品编号';
comment on column ${iml_schema}.agt_make_card_appl_info_h.card_corp_abbr is '卡商简称';
comment on column ${iml_schema}.agt_make_card_appl_info_h.make_card_dt is '制卡日期';
comment on column ${iml_schema}.agt_make_card_appl_info_h.make_card_type_cd is '制卡类型代码';
comment on column ${iml_schema}.agt_make_card_appl_info_h.make_card_appl_type_cd is '制卡申请类型代码';
comment on column ${iml_schema}.agt_make_card_appl_info_h.make_card_qtty is '制卡数量';
comment on column ${iml_schema}.agt_make_card_appl_info_h.make_card_status_cd is '制卡状态代码';
comment on column ${iml_schema}.agt_make_card_appl_info_h.make_card_doc_batch_no is '制卡文件批次号';
comment on column ${iml_schema}.agt_make_card_appl_info_h.pre_make_card_cty_rg_cd is '预制卡国家和地区代码';
comment on column ${iml_schema}.agt_make_card_appl_info_h.lucky_card_flg is '吉祥卡标志';
comment on column ${iml_schema}.agt_make_card_appl_info_h.tran_teller_id is '交易柜员编号';
comment on column ${iml_schema}.agt_make_card_appl_info_h.tran_org_id is '交易机构编号';
comment on column ${iml_schema}.agt_make_card_appl_info_h.tran_tm is '交易时间';
comment on column ${iml_schema}.agt_make_card_appl_info_h.choice_num_type_cd is '选号类型代码';
comment on column ${iml_schema}.agt_make_card_appl_info_h.card_draw_way_cd is '卡片领取方式代码';
comment on column ${iml_schema}.agt_make_card_appl_info_h.recv_flg is '签收标志';
comment on column ${iml_schema}.agt_make_card_appl_info_h.dep_vouch_cate_cd is '存款凭证类别代码';
comment on column ${iml_schema}.agt_make_card_appl_info_h.remark is '备注';
comment on column ${iml_schema}.agt_make_card_appl_info_h.start_dt is '开始时间';
comment on column ${iml_schema}.agt_make_card_appl_info_h.end_dt is '结束时间';
comment on column ${iml_schema}.agt_make_card_appl_info_h.id_mark is '增删标志';
comment on column ${iml_schema}.agt_make_card_appl_info_h.src_table_name is '源表名称';
comment on column ${iml_schema}.agt_make_card_appl_info_h.job_cd is '任务编码';
comment on column ${iml_schema}.agt_make_card_appl_info_h.etl_timestamp is 'ETL处理时间戳';
