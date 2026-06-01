/*
Purpose:    整合模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iml agt_imp_coll_info_h
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iml_schema}.agt_imp_coll_info_h
whenever sqlerror continue none;
drop table ${iml_schema}.agt_imp_coll_info_h purge;

whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.agt_imp_coll_info_h(
    agt_id varchar2(250) -- 协议编号
    ,lp_id varchar2(100) -- 法人编号
    ,tran_flow_num varchar2(100) -- 交易流水号
    ,tran_id varchar2(100) -- 交易编号
    ,tran_name varchar2(750) -- 交易名称
    ,cargo_type_cd varchar2(30) -- 货物类型代码
    ,cargo_auth_cd varchar2(30) -- 货物授权代码
    ,cargo_arrive_dt date -- 货物到达日期
    ,revid_cargo_dt date -- 收货日期
    ,sugst_dt date -- 提示日期
    ,ship_send_out_dt date -- 发船日期
    ,create_date date -- 创建日期
    ,advise_dt date -- 通知日期
    ,effect_dt date -- 生效日期
    ,invalid_dt date -- 失效日期
    ,exp_dt date -- 到期日期
    ,effect_days number(10) -- 生效天数
    ,dt_type_cd varchar2(30) -- 日期类型代码
    ,issue_dt date -- 开证日期
    ,coll_type_cd varchar2(30) -- 代收类型代码
    ,bus_oper_teller_id varchar2(100) -- 业务经办柜员编号
    ,doc_type_cd varchar2(30) -- 单据类型代码
    ,doc_status_cd varchar2(30) -- 单据状态代码
    ,doc_id varchar2(100) -- 单据编号
    ,doc_send_out_dt date -- 发单日期
    ,doc_send_out_way_cd varchar2(30) -- 发单方式代码
    ,dispatch_site varchar2(750) -- 发货地点
    ,cargo_arrive_site varchar2(750) -- 到货地点
    ,pay_dir_cd varchar2(30) -- 付款方向代码
    ,delay_pay_type_cd varchar2(30) -- 延期付款类型代码
    ,cty_id varchar2(100) -- 国家编号
    ,acpt_dt date -- 承兑日期
    ,bank_guar_flg varchar2(10) -- 银行担保标志
    ,traff_guar_exp_dt date -- 运输担保到期日期
    ,pick_goods_type_cd varchar2(30) -- 提货类型代码
    ,pick_goods_dt date -- 提货日期
    ,goods_flg varchar2(10) -- 放货标志
    ,blend_pay_flg varchar2(10) -- 混合付款标志
    ,free_pay_present_flg varchar2(10) -- 免付款交单标志
    ,nomal_tran_flg varchar2(10) -- 正常交易标志
    ,coll_bk_fee_refuse_pay_give_up_idf varchar2(15) -- 代收行费用遭拒付时放弃标识
    ,ghb_fee_refuse_pay_give_up_idf varchar2(15) -- 我方费用遭拒付时放弃标识
    ,send_face_letr_flg varchar2(10) -- 发送面函标志
    ,nra_recvbl_flg varchar2(10) -- NRA收款标志
    ,clear_chn_cd varchar2(30) -- 清算渠道代码
    ,refuse_pay_flg_cd varchar2(30) -- 拒付标志代码
    ,belong_org_id varchar2(100) -- 所属机构编号
    ,oper_org_id varchar2(100) -- 经办机构编号
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
grant select on ${iml_schema}.agt_imp_coll_info_h to ${icl_schema};
grant select on ${iml_schema}.agt_imp_coll_info_h to ${idl_schema};
grant select on ${iml_schema}.agt_imp_coll_info_h to ${iel_schema};

-- comment
comment on table ${iml_schema}.agt_imp_coll_info_h is '进口代收信息历史';
comment on column ${iml_schema}.agt_imp_coll_info_h.agt_id is '协议编号';
comment on column ${iml_schema}.agt_imp_coll_info_h.lp_id is '法人编号';
comment on column ${iml_schema}.agt_imp_coll_info_h.tran_flow_num is '交易流水号';
comment on column ${iml_schema}.agt_imp_coll_info_h.tran_id is '交易编号';
comment on column ${iml_schema}.agt_imp_coll_info_h.tran_name is '交易名称';
comment on column ${iml_schema}.agt_imp_coll_info_h.cargo_type_cd is '货物类型代码';
comment on column ${iml_schema}.agt_imp_coll_info_h.cargo_auth_cd is '货物授权代码';
comment on column ${iml_schema}.agt_imp_coll_info_h.cargo_arrive_dt is '货物到达日期';
comment on column ${iml_schema}.agt_imp_coll_info_h.revid_cargo_dt is '收货日期';
comment on column ${iml_schema}.agt_imp_coll_info_h.sugst_dt is '提示日期';
comment on column ${iml_schema}.agt_imp_coll_info_h.ship_send_out_dt is '发船日期';
comment on column ${iml_schema}.agt_imp_coll_info_h.create_date is '创建日期';
comment on column ${iml_schema}.agt_imp_coll_info_h.advise_dt is '通知日期';
comment on column ${iml_schema}.agt_imp_coll_info_h.effect_dt is '生效日期';
comment on column ${iml_schema}.agt_imp_coll_info_h.invalid_dt is '失效日期';
comment on column ${iml_schema}.agt_imp_coll_info_h.exp_dt is '到期日期';
comment on column ${iml_schema}.agt_imp_coll_info_h.effect_days is '生效天数';
comment on column ${iml_schema}.agt_imp_coll_info_h.dt_type_cd is '日期类型代码';
comment on column ${iml_schema}.agt_imp_coll_info_h.issue_dt is '开证日期';
comment on column ${iml_schema}.agt_imp_coll_info_h.coll_type_cd is '代收类型代码';
comment on column ${iml_schema}.agt_imp_coll_info_h.bus_oper_teller_id is '业务经办柜员编号';
comment on column ${iml_schema}.agt_imp_coll_info_h.doc_type_cd is '单据类型代码';
comment on column ${iml_schema}.agt_imp_coll_info_h.doc_status_cd is '单据状态代码';
comment on column ${iml_schema}.agt_imp_coll_info_h.doc_id is '单据编号';
comment on column ${iml_schema}.agt_imp_coll_info_h.doc_send_out_dt is '发单日期';
comment on column ${iml_schema}.agt_imp_coll_info_h.doc_send_out_way_cd is '发单方式代码';
comment on column ${iml_schema}.agt_imp_coll_info_h.dispatch_site is '发货地点';
comment on column ${iml_schema}.agt_imp_coll_info_h.cargo_arrive_site is '到货地点';
comment on column ${iml_schema}.agt_imp_coll_info_h.pay_dir_cd is '付款方向代码';
comment on column ${iml_schema}.agt_imp_coll_info_h.delay_pay_type_cd is '延期付款类型代码';
comment on column ${iml_schema}.agt_imp_coll_info_h.cty_id is '国家编号';
comment on column ${iml_schema}.agt_imp_coll_info_h.acpt_dt is '承兑日期';
comment on column ${iml_schema}.agt_imp_coll_info_h.bank_guar_flg is '银行担保标志';
comment on column ${iml_schema}.agt_imp_coll_info_h.traff_guar_exp_dt is '运输担保到期日期';
comment on column ${iml_schema}.agt_imp_coll_info_h.pick_goods_type_cd is '提货类型代码';
comment on column ${iml_schema}.agt_imp_coll_info_h.pick_goods_dt is '提货日期';
comment on column ${iml_schema}.agt_imp_coll_info_h.goods_flg is '放货标志';
comment on column ${iml_schema}.agt_imp_coll_info_h.blend_pay_flg is '混合付款标志';
comment on column ${iml_schema}.agt_imp_coll_info_h.free_pay_present_flg is '免付款交单标志';
comment on column ${iml_schema}.agt_imp_coll_info_h.nomal_tran_flg is '正常交易标志';
comment on column ${iml_schema}.agt_imp_coll_info_h.coll_bk_fee_refuse_pay_give_up_idf is '代收行费用遭拒付时放弃标识';
comment on column ${iml_schema}.agt_imp_coll_info_h.ghb_fee_refuse_pay_give_up_idf is '我方费用遭拒付时放弃标识';
comment on column ${iml_schema}.agt_imp_coll_info_h.send_face_letr_flg is '发送面函标志';
comment on column ${iml_schema}.agt_imp_coll_info_h.nra_recvbl_flg is 'NRA收款标志';
comment on column ${iml_schema}.agt_imp_coll_info_h.clear_chn_cd is '清算渠道代码';
comment on column ${iml_schema}.agt_imp_coll_info_h.refuse_pay_flg_cd is '拒付标志代码';
comment on column ${iml_schema}.agt_imp_coll_info_h.belong_org_id is '所属机构编号';
comment on column ${iml_schema}.agt_imp_coll_info_h.oper_org_id is '经办机构编号';
comment on column ${iml_schema}.agt_imp_coll_info_h.start_dt is '开始时间';
comment on column ${iml_schema}.agt_imp_coll_info_h.end_dt is '结束时间';
comment on column ${iml_schema}.agt_imp_coll_info_h.id_mark is '增删标志';
comment on column ${iml_schema}.agt_imp_coll_info_h.src_table_name is '源表名称';
comment on column ${iml_schema}.agt_imp_coll_info_h.job_cd is '任务编码';
comment on column ${iml_schema}.agt_imp_coll_info_h.etl_timestamp is 'ETL处理时间戳';
