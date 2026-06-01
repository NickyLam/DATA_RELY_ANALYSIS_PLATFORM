/*
Purpose:    应用集市层-建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd idl_icrm_agt_loan_apv
CreateDate: 20180515
FileType:   DML
Logs:
    zjj 2018-05-15 新建表本
*/

set timing on

-- 1 alter parallel
alter session force parallel query parallel 4;
alter session force parallel dml parallel 4;
-- alter session force parallel ddl parallel 4;


-- 2.1 drop timeout partition and add partition
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none;
alter table ${idl_schema}.icrm_agt_loan_apv drop partition p_${last_date};
alter table ${idl_schema}.icrm_agt_loan_apv drop partition p_${batch_date};

-- 2.2 add today partition
whenever sqlerror exit sql.sqlcode;
alter table ${idl_schema}.icrm_agt_loan_apv add  partition p_${batch_date} values (to_date('${batch_date}','yyyymmdd'));

-- 2.3 insert data target table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ into ${idl_schema}.icrm_agt_loan_apv partition for (to_date('${batch_date}','yyyymmdd')) (
    etl_dt  -- 数据日期
    ,agt_id  -- 协议编号
    ,lp_id  -- 法人编号
    ,apv_flow_num  -- 审批流水号
    ,rela_appl_flow_num  -- 相关申请流水号
    ,happ_dt  -- 发生日期
    ,party_id  -- 当事人编号
    ,bus_breed_id  -- 业务品种编号
    ,happ_type_cd  -- 发生类型代码
    ,bank_fin_tot  -- 银行融资总额
    ,curr_cd  -- 币种代码
    ,apv_amt  -- 审批金额
    ,tenor_mon  -- 期限月
    ,loan_usage_descb  -- 贷款用途描述
    ,oper_org_id  -- 经办机构编号
    ,oper_teller_id  -- 经办柜员编号
    ,oper_dt  -- 经办日期
    ,rgst_org_id  -- 登记机构编号
    ,rgst_teller_id  -- 登记柜员编号
    ,rgst_dt  -- 登记日期
    ,modif_dt  -- 变更日期
    ,reply_type_cd  -- 批复类型代码
    ,circl_flg  -- 循环标志
    ,apved_dt  -- 审批通过日期
    ,lmt_circl_flg  -- 额度循环标志
    ,effect_flg  -- 生效标志
    ,loan_tenor  -- 贷款期限
    ,attach_rgst_flg  -- 补登标志
    ,turn_crdt_flg  -- 转授信标志
    ,matn_flg  -- 维护标志
    ,host_bk_name  -- 主办行行名名称
    ,patip_loan_bank_name  -- 参贷行行名名称
    ,agent_bank_name  -- 代理行行名名称
    ,agent_patip_loan_flg  -- 代理参贷标志
    ,final_jud_pass_dt  -- 终审通过日期
    ,crdt_rg_cd  -- 授信区域代码
    ,invo_estate_fin_flg  -- 涉及房地产融资标志
    ,invo_gover_class_fin_flg  -- 涉及政府类融资标志
    ,consm_serv_class_fin_flg  -- 消费服务类融资标志
    ,br_build_ifin_flg  -- 一带一路建设投融资标志
    ,green_crdt_fin_flg  -- 绿色信贷融资标志
    ,class_crdt_flg  -- 类信贷标志
    ,reply_id  -- 批复编号
    ,final_apv_opinion  -- 最终审批意见
    ,final_apv_opinion_2  -- 最终审批意见2
    ,job_cd  -- 任务代码
    ,etl_timestamp  -- 数据处理时间
)
select
    to_date('${batch_date}','yyyymmdd') as etl_dt  -- 数据日期
    ,replace(replace(t1.agt_id,chr(13),''),chr(10),'')  -- 协议编号
    ,replace(replace(t1.lp_id,chr(13),''),chr(10),'')  -- 法人编号
    ,replace(replace(t1.apv_flow_num,chr(13),''),chr(10),'')  -- 审批流水号
    ,replace(replace(t1.rela_appl_flow_num,chr(13),''),chr(10),'')  -- 相关申请流水号
    ,t1.happ_dt  -- 发生日期
    ,replace(replace(t1.party_id,chr(13),''),chr(10),'')  -- 当事人编号
    ,replace(replace(t1.bus_breed_id,chr(13),''),chr(10),'')  -- 业务品种编号
    ,replace(replace(t1.happ_type_cd,chr(13),''),chr(10),'')  -- 发生类型代码
    ,t1.bank_fin_tot  -- 银行融资总额
    ,replace(replace(t1.curr_cd,chr(13),''),chr(10),'')  -- 币种代码
    ,t1.apv_amt  -- 审批金额
    ,t1.tenor_mon  -- 期限月
    ,replace(replace(t1.loan_usage_descb,chr(13),''),chr(10),'')  -- 贷款用途描述
    ,replace(replace(t1.oper_org_id,chr(13),''),chr(10),'')  -- 经办机构编号
    ,replace(replace(t1.oper_teller_id,chr(13),''),chr(10),'')  -- 经办柜员编号
    ,t1.oper_dt  -- 经办日期
    ,replace(replace(t1.rgst_org_id,chr(13),''),chr(10),'')  -- 登记机构编号
    ,replace(replace(t1.rgst_teller_id,chr(13),''),chr(10),'')  -- 登记柜员编号
    ,t1.rgst_dt  -- 登记日期
    ,t1.modif_dt  -- 变更日期
    ,replace(replace(t1.reply_type_cd,chr(13),''),chr(10),'')  -- 批复类型代码
    ,replace(replace(t1.circl_flg,chr(13),''),chr(10),'')  -- 循环标志
    ,t1.apved_dt  -- 审批通过日期
    ,replace(replace(t1.lmt_circl_flg,chr(13),''),chr(10),'')  -- 额度循环标志
    ,replace(replace(t1.effect_flg,chr(13),''),chr(10),'')  -- 生效标志
    ,t1.loan_tenor  -- 贷款期限
    ,replace(replace(t1.attach_rgst_flg,chr(13),''),chr(10),'')  -- 补登标志
    ,replace(replace(t1.turn_crdt_flg,chr(13),''),chr(10),'')  -- 转授信标志
    ,replace(replace(t1.matn_flg,chr(13),''),chr(10),'')  -- 维护标志
    ,replace(replace(t1.host_bk_name,chr(13),''),chr(10),'')  -- 主办行行名名称
    ,replace(replace(t1.patip_loan_bank_name,chr(13),''),chr(10),'')  -- 参贷行行名名称
    ,replace(replace(t1.agent_bank_name,chr(13),''),chr(10),'')  -- 代理行行名名称
    ,replace(replace(t1.agent_patip_loan_flg,chr(13),''),chr(10),'')  -- 代理参贷标志
    ,t1.final_jud_pass_dt  -- 终审通过日期
    ,replace(replace(t1.crdt_rg_cd,chr(13),''),chr(10),'')  -- 授信区域代码
    ,replace(replace(t1.invo_estate_fin_flg,chr(13),''),chr(10),'')  -- 涉及房地产融资标志
    ,replace(replace(t1.invo_gover_class_fin_flg,chr(13),''),chr(10),'')  -- 涉及政府类融资标志
    ,replace(replace(t1.consm_serv_class_fin_flg,chr(13),''),chr(10),'')  -- 消费服务类融资标志
    ,replace(replace(t1.br_build_ifin_flg,chr(13),''),chr(10),'')  -- 一带一路建设投融资标志
    ,replace(replace(t1.green_crdt_fin_flg,chr(13),''),chr(10),'')  -- 绿色信贷融资标志
    ,replace(replace(t1.class_crdt_flg,chr(13),''),chr(10),'')  -- 类信贷标志
    ,replace(replace(t1.reply_id,chr(13),''),chr(10),'')  -- 批复编号
    ,replace(replace(t1.final_apv_opinion,chr(13),''),chr(10),'')  -- 最终审批意见
    ,replace(replace(t1.final_apv_opinion_2,chr(13),''),chr(10),'')  -- 最终审批意见2
    ,replace(replace(t1.job_cd,chr(13),''),chr(10),'')  -- 任务代码
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp   --数据处理时间
from ${iml_schema}.agt_loan_apv t1    --公司贷款审批
where t1.update_dt= to_date('${batch_date}','yyyymmdd') and t1.id_mark <> 'D' ;
commit;


-- 4 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${idl_schema}',tabname => 'icrm_agt_loan_apv',partname => 'p_${batch_date}', granularity => 'PARTITION', degree => 8, cascade => true);