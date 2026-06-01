/*
Purpose:    整合模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iml agt_astconsv_dubil_rela_h
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iml_schema}.agt_astconsv_dubil_rela_h
whenever sqlerror continue none;
drop table ${iml_schema}.agt_astconsv_dubil_rela_h purge;

whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.agt_astconsv_dubil_rela_h(
    appl_id varchar2(100) -- 申请编号
    ,lp_id varchar2(100) -- 法人编号
    ,flow_num varchar2(100) -- 流水号
    ,rela_flow_num varchar2(100) -- 关联流水号
    ,bus_type_cd varchar2(60) -- 业务类型代码
    ,ths_tm_asset_cls_cd varchar2(60) -- 本次资产分类代码
    ,aldy_cmplt_flg varchar2(10) -- 已完善标志
    ,disp_plan_and_prog_descb varchar2(4000) -- 处置计划及进展描述
    ,on_acct_seq_num varchar2(100) -- 挂账序号
    ,derate_bf_pric_tot number(30,8) -- 减免前本金汇总
    ,derate_pric number(30,8) -- 减免本金
    ,derate_provi_comp_int number(30,8) -- 减免计提复利
    ,derate_provi_int number(30,8) -- 减免计提利息
    ,derate_provi_pnlt number(30,8) -- 减免计提罚息
    ,derate_ovdue_pric number(30,8) -- 减免逾期本金
    ,derate_int_rat number(30,8) -- 减免利率
    ,derate_actl_owe_comp_int number(30,8) -- 减免实欠复利
    ,derate_actl_owe_int number(30,8) -- 减免实欠利息
    ,derate_actl_owe_pnlt number(30,8) -- 减免实欠罚息
    ,accti_status_cd varchar2(30) -- 核算状态代码
    ,last_asset_cls_cd varchar2(60) -- 上一资产分类代码
    ,asset_descb varchar2(4000) -- 资产线索描述
    ,core_sucs_return_rest_flg varchar2(10) -- 核心成功返回结果标志
    ,core_return_rest varchar2(4000) -- 核心返回结果
    ,ths_return_post_acct_recl_amt number(30,8) -- 本次回款后应收款金额
    ,ths_return_bf_acct_recv_amt number(30,8) -- 本次回款前应收款金额
    ,acm_return_amt number(30,8) -- 累计回款金额
    ,revs_status_cd varchar2(30) -- 冲正状态代码
    ,assign_tran_price number(30,8) -- 分配转让价格
    ,assign_tran_fst_price number(30,8) -- 分配转让首期价格
    ,assign_tran_acct_recvbl_price number(30,8) -- 分配转让应收款价格
    ,wrt_off_adv_fee number(30,8) -- 核销代垫费用
    ,suit_prog_descb varchar2(4000) -- 诉讼进展描述
    ,rgst_dt date -- 登记日期
    ,rgst_belong_org_id varchar2(100) -- 登记所属机构编号
    ,rgst_teller_id varchar2(100) -- 登记柜员编号
    ,update_teller_id varchar2(100) -- 更新柜员编号
    ,update_org_id varchar2(100) -- 更新机构编号
    ,remark varchar2(4000) -- 备注
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
grant select on ${iml_schema}.agt_astconsv_dubil_rela_h to ${icl_schema};
grant select on ${iml_schema}.agt_astconsv_dubil_rela_h to ${idl_schema};
grant select on ${iml_schema}.agt_astconsv_dubil_rela_h to ${iel_schema};

-- comment
comment on table ${iml_schema}.agt_astconsv_dubil_rela_h is '资产保全与借据关联信息历史';
comment on column ${iml_schema}.agt_astconsv_dubil_rela_h.appl_id is '申请编号';
comment on column ${iml_schema}.agt_astconsv_dubil_rela_h.lp_id is '法人编号';
comment on column ${iml_schema}.agt_astconsv_dubil_rela_h.flow_num is '流水号';
comment on column ${iml_schema}.agt_astconsv_dubil_rela_h.rela_flow_num is '关联流水号';
comment on column ${iml_schema}.agt_astconsv_dubil_rela_h.bus_type_cd is '业务类型代码';
comment on column ${iml_schema}.agt_astconsv_dubil_rela_h.ths_tm_asset_cls_cd is '本次资产分类代码';
comment on column ${iml_schema}.agt_astconsv_dubil_rela_h.aldy_cmplt_flg is '已完善标志';
comment on column ${iml_schema}.agt_astconsv_dubil_rela_h.disp_plan_and_prog_descb is '处置计划及进展描述';
comment on column ${iml_schema}.agt_astconsv_dubil_rela_h.on_acct_seq_num is '挂账序号';
comment on column ${iml_schema}.agt_astconsv_dubil_rela_h.derate_bf_pric_tot is '减免前本金汇总';
comment on column ${iml_schema}.agt_astconsv_dubil_rela_h.derate_pric is '减免本金';
comment on column ${iml_schema}.agt_astconsv_dubil_rela_h.derate_provi_comp_int is '减免计提复利';
comment on column ${iml_schema}.agt_astconsv_dubil_rela_h.derate_provi_int is '减免计提利息';
comment on column ${iml_schema}.agt_astconsv_dubil_rela_h.derate_provi_pnlt is '减免计提罚息';
comment on column ${iml_schema}.agt_astconsv_dubil_rela_h.derate_ovdue_pric is '减免逾期本金';
comment on column ${iml_schema}.agt_astconsv_dubil_rela_h.derate_int_rat is '减免利率';
comment on column ${iml_schema}.agt_astconsv_dubil_rela_h.derate_actl_owe_comp_int is '减免实欠复利';
comment on column ${iml_schema}.agt_astconsv_dubil_rela_h.derate_actl_owe_int is '减免实欠利息';
comment on column ${iml_schema}.agt_astconsv_dubil_rela_h.derate_actl_owe_pnlt is '减免实欠罚息';
comment on column ${iml_schema}.agt_astconsv_dubil_rela_h.accti_status_cd is '核算状态代码';
comment on column ${iml_schema}.agt_astconsv_dubil_rela_h.last_asset_cls_cd is '上一资产分类代码';
comment on column ${iml_schema}.agt_astconsv_dubil_rela_h.asset_descb is '资产线索描述';
comment on column ${iml_schema}.agt_astconsv_dubil_rela_h.core_sucs_return_rest_flg is '核心成功返回结果标志';
comment on column ${iml_schema}.agt_astconsv_dubil_rela_h.core_return_rest is '核心返回结果';
comment on column ${iml_schema}.agt_astconsv_dubil_rela_h.ths_return_post_acct_recl_amt is '本次回款后应收款金额';
comment on column ${iml_schema}.agt_astconsv_dubil_rela_h.ths_return_bf_acct_recv_amt is '本次回款前应收款金额';
comment on column ${iml_schema}.agt_astconsv_dubil_rela_h.acm_return_amt is '累计回款金额';
comment on column ${iml_schema}.agt_astconsv_dubil_rela_h.revs_status_cd is '冲正状态代码';
comment on column ${iml_schema}.agt_astconsv_dubil_rela_h.assign_tran_price is '分配转让价格';
comment on column ${iml_schema}.agt_astconsv_dubil_rela_h.assign_tran_fst_price is '分配转让首期价格';
comment on column ${iml_schema}.agt_astconsv_dubil_rela_h.assign_tran_acct_recvbl_price is '分配转让应收款价格';
comment on column ${iml_schema}.agt_astconsv_dubil_rela_h.wrt_off_adv_fee is '核销代垫费用';
comment on column ${iml_schema}.agt_astconsv_dubil_rela_h.suit_prog_descb is '诉讼进展描述';
comment on column ${iml_schema}.agt_astconsv_dubil_rela_h.rgst_dt is '登记日期';
comment on column ${iml_schema}.agt_astconsv_dubil_rela_h.rgst_belong_org_id is '登记所属机构编号';
comment on column ${iml_schema}.agt_astconsv_dubil_rela_h.rgst_teller_id is '登记柜员编号';
comment on column ${iml_schema}.agt_astconsv_dubil_rela_h.update_teller_id is '更新柜员编号';
comment on column ${iml_schema}.agt_astconsv_dubil_rela_h.update_org_id is '更新机构编号';
comment on column ${iml_schema}.agt_astconsv_dubil_rela_h.remark is '备注';
comment on column ${iml_schema}.agt_astconsv_dubil_rela_h.start_dt is '开始时间';
comment on column ${iml_schema}.agt_astconsv_dubil_rela_h.end_dt is '结束时间';
comment on column ${iml_schema}.agt_astconsv_dubil_rela_h.id_mark is '增删标志';
comment on column ${iml_schema}.agt_astconsv_dubil_rela_h.src_table_name is '源表名称';
comment on column ${iml_schema}.agt_astconsv_dubil_rela_h.job_cd is '任务编码';
comment on column ${iml_schema}.agt_astconsv_dubil_rela_h.etl_timestamp is 'ETL处理时间戳';
