/*
Purpose:    整合模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iml agt_exp_coll_h
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iml_schema}.agt_exp_coll_h
whenever sqlerror continue none;
drop table ${iml_schema}.agt_exp_coll_h purge;

whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.agt_exp_coll_h(
    agt_id varchar2(250) -- 协议编号
    ,lp_id varchar2(60) -- 法人编号
    ,src_agt_id varchar2(60) -- 源协议编号
    ,bus_id varchar2(60) -- 业务编号
    ,tran_descb varchar2(375) -- 交易描述
    ,shipment_dt date -- 装船日期
    ,sugst_dt date -- 提示日期
    ,present_dt date -- 交单日期
    ,send_bill_dt date -- 寄单日期
    ,advise_dt date -- 通知日期
    ,valid_pay_dt date -- 有效付款日期
    ,bus_cmplt_dt date -- 业务完成日期
    ,coll_type_cd varchar2(30) -- 跟单托收类型代码
    ,vp_days number(10) -- 效期天数
    ,tenor_type_cd varchar2(30) -- 期限类型代码
    ,traff_doc_type_cd varchar2(30) -- 运输单据类型代码
    ,traff_doc_id varchar2(60) -- 运输单据编号
    ,traff_dt date -- 运输日期
    ,traff_tool_type_cd varchar2(30) -- 运输工具类型代码
    ,coll_bk_fee_refuse_flg varchar2(10) -- 代收行费用遭拒付时放弃标志
    ,ghb_refuse_pay_flg varchar2(10) -- 我方费用遭拒付时放弃标志
    ,pay_src_cd varchar2(30) -- 付款来源代码
    ,cty_cd varchar2(30) -- 国家代码
    ,cargo_type_cd varchar2(30) -- 货物类型代码
    ,acquiri_bank_rgst_dt date -- 收单行登记日期
    ,bus_teller_id varchar2(60) -- 业务柜员编号
    ,free_pay_present_flg varchar2(10) -- 免付款交单标志
    ,dir_coll_flg varchar2(10) -- 直接托收标志
    ,clean_coll_open_dt date -- 光票托收开立日期
    ,blend_pay_flg varchar2(10) -- 混合付款标志
    ,delay_pay_type_cd varchar2(30) -- 延期付款类型代码
    ,doc_status_cd varchar2(30) -- 单据状态代码
    ,secd_recv_bank_cd varchar2(30) -- 第二接收行代码
    ,overs_comm_fee number(18,3) -- 国外手续费
    ,belong_org_id varchar2(60) -- 所属机构编号
    ,trast_org_id varchar2(60) -- 办理机构编号
    ,nra_pay_flg varchar2(10) -- NRA付款标志
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
grant select on ${iml_schema}.agt_exp_coll_h to ${icl_schema};
grant select on ${iml_schema}.agt_exp_coll_h to ${idl_schema};
grant select on ${iml_schema}.agt_exp_coll_h to ${iel_schema};

-- comment
comment on table ${iml_schema}.agt_exp_coll_h is '出口托收历史';
comment on column ${iml_schema}.agt_exp_coll_h.agt_id is '协议编号';
comment on column ${iml_schema}.agt_exp_coll_h.lp_id is '法人编号';
comment on column ${iml_schema}.agt_exp_coll_h.src_agt_id is '源协议编号';
comment on column ${iml_schema}.agt_exp_coll_h.bus_id is '业务编号';
comment on column ${iml_schema}.agt_exp_coll_h.tran_descb is '交易描述';
comment on column ${iml_schema}.agt_exp_coll_h.shipment_dt is '装船日期';
comment on column ${iml_schema}.agt_exp_coll_h.sugst_dt is '提示日期';
comment on column ${iml_schema}.agt_exp_coll_h.present_dt is '交单日期';
comment on column ${iml_schema}.agt_exp_coll_h.send_bill_dt is '寄单日期';
comment on column ${iml_schema}.agt_exp_coll_h.advise_dt is '通知日期';
comment on column ${iml_schema}.agt_exp_coll_h.valid_pay_dt is '有效付款日期';
comment on column ${iml_schema}.agt_exp_coll_h.bus_cmplt_dt is '业务完成日期';
comment on column ${iml_schema}.agt_exp_coll_h.coll_type_cd is '跟单托收类型代码';
comment on column ${iml_schema}.agt_exp_coll_h.vp_days is '效期天数';
comment on column ${iml_schema}.agt_exp_coll_h.tenor_type_cd is '期限类型代码';
comment on column ${iml_schema}.agt_exp_coll_h.traff_doc_type_cd is '运输单据类型代码';
comment on column ${iml_schema}.agt_exp_coll_h.traff_doc_id is '运输单据编号';
comment on column ${iml_schema}.agt_exp_coll_h.traff_dt is '运输日期';
comment on column ${iml_schema}.agt_exp_coll_h.traff_tool_type_cd is '运输工具类型代码';
comment on column ${iml_schema}.agt_exp_coll_h.coll_bk_fee_refuse_flg is '代收行费用遭拒付时放弃标志';
comment on column ${iml_schema}.agt_exp_coll_h.ghb_refuse_pay_flg is '我方费用遭拒付时放弃标志';
comment on column ${iml_schema}.agt_exp_coll_h.pay_src_cd is '付款来源代码';
comment on column ${iml_schema}.agt_exp_coll_h.cty_cd is '国家代码';
comment on column ${iml_schema}.agt_exp_coll_h.cargo_type_cd is '货物类型代码';
comment on column ${iml_schema}.agt_exp_coll_h.acquiri_bank_rgst_dt is '收单行登记日期';
comment on column ${iml_schema}.agt_exp_coll_h.bus_teller_id is '业务柜员编号';
comment on column ${iml_schema}.agt_exp_coll_h.free_pay_present_flg is '免付款交单标志';
comment on column ${iml_schema}.agt_exp_coll_h.dir_coll_flg is '直接托收标志';
comment on column ${iml_schema}.agt_exp_coll_h.clean_coll_open_dt is '光票托收开立日期';
comment on column ${iml_schema}.agt_exp_coll_h.blend_pay_flg is '混合付款标志';
comment on column ${iml_schema}.agt_exp_coll_h.delay_pay_type_cd is '延期付款类型代码';
comment on column ${iml_schema}.agt_exp_coll_h.doc_status_cd is '单据状态代码';
comment on column ${iml_schema}.agt_exp_coll_h.secd_recv_bank_cd is '第二接收行代码';
comment on column ${iml_schema}.agt_exp_coll_h.overs_comm_fee is '国外手续费';
comment on column ${iml_schema}.agt_exp_coll_h.belong_org_id is '所属机构编号';
comment on column ${iml_schema}.agt_exp_coll_h.trast_org_id is '办理机构编号';
comment on column ${iml_schema}.agt_exp_coll_h.nra_pay_flg is 'NRA付款标志';
comment on column ${iml_schema}.agt_exp_coll_h.start_dt is '开始时间';
comment on column ${iml_schema}.agt_exp_coll_h.end_dt is '结束时间';
comment on column ${iml_schema}.agt_exp_coll_h.id_mark is '增删标志';
comment on column ${iml_schema}.agt_exp_coll_h.src_table_name is '源表名称';
comment on column ${iml_schema}.agt_exp_coll_h.job_cd is '任务编码';
comment on column ${iml_schema}.agt_exp_coll_h.etl_timestamp is 'ETL处理时间戳';
