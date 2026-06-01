/*
Purpose:    整合模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iml_agt_astconsv_dubil_rela_h_icmsf1
CreateDate: 20180515
Logs:
    zjj 2018-05-15 新建表本
*/

set timing on

-- 1 alter parallel
alter session force parallel query parallel 4;
alter session force parallel dml parallel 4;
-- alter session force parallel ddl parallel 1;

-- 2.1 create backup table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
alter table ${iml_schema}.agt_astconsv_dubil_rela_h add partition p_icmsf1 values ('icmsf1')(
        subpartition p_icmsf1_19000101 values (to_date('19000101','yyyymmdd'))
        ,subpartition p_icmsf1_20991231 values (to_date('20991231','yyyymmdd'))
    )
;

-- if backup table is exists, mean script if failed on last time
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
create table ${iml_schema}.agt_astconsv_dubil_rela_h_icmsf1_bk nologging
compress ${option_switch} for query high
as
select * from ${iml_schema}.agt_astconsv_dubil_rela_h partition for ('icmsf1')
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd')
;

-- 2.2 drop temp table
whenever sqlerror continue none ;
-- it is no need to check when this segment SQL was return faied
drop table ${iml_schema}.agt_astconsv_dubil_rela_h_icmsf1_tm purge;
drop table ${iml_schema}.agt_astconsv_dubil_rela_h_icmsf1_op purge;
drop table ${iml_schema}.agt_astconsv_dubil_rela_h_icmsf1_cl purge;

-- 2.3 create temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.agt_astconsv_dubil_rela_h_icmsf1_tm nologging
compress ${option_switch} for query high
as select
    appl_id -- 申请编号
    ,lp_id -- 法人编号
    ,flow_num -- 流水号
    ,rela_flow_num -- 关联流水号
    ,bus_type_cd -- 业务类型代码
    ,ths_tm_asset_cls_cd -- 本次资产分类代码
    ,aldy_cmplt_flg -- 已完善标志
    ,disp_plan_and_prog_descb -- 处置计划及进展描述
    ,on_acct_seq_num -- 挂账序号
    ,derate_bf_pric_tot -- 减免前本金汇总
    ,derate_pric -- 减免本金
    ,derate_provi_comp_int -- 减免计提复利
    ,derate_provi_int -- 减免计提利息
    ,derate_provi_pnlt -- 减免计提罚息
    ,derate_ovdue_pric -- 减免逾期本金
    ,derate_int_rat -- 减免利率
    ,derate_actl_owe_comp_int -- 减免实欠复利
    ,derate_actl_owe_int -- 减免实欠利息
    ,derate_actl_owe_pnlt -- 减免实欠罚息
    ,accti_status_cd -- 核算状态代码
    ,last_asset_cls_cd -- 上一资产分类代码
    ,asset_descb -- 资产线索描述
    ,core_sucs_return_rest_flg -- 核心成功返回结果标志
    ,core_return_rest -- 核心返回结果
    ,ths_return_post_acct_recl_amt -- 本次回款后应收款金额
    ,ths_return_bf_acct_recv_amt -- 本次回款前应收款金额
    ,acm_return_amt -- 累计回款金额
    ,revs_status_cd -- 冲正状态代码
    ,assign_tran_price -- 分配转让价格
    ,assign_tran_fst_price -- 分配转让首期价格
    ,assign_tran_acct_recvbl_price -- 分配转让应收款价格
    ,wrt_off_adv_fee -- 核销代垫费用
    ,suit_prog_descb -- 诉讼进展描述
    ,rgst_dt -- 登记日期
    ,rgst_belong_org_id -- 登记所属机构编号
    ,rgst_teller_id -- 登记柜员编号
    ,update_teller_id -- 更新柜员编号
    ,update_org_id -- 更新机构编号
    ,remark -- 备注
    ,to_date('${batch_date}', 'yyyymmdd') as etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
from ${iml_schema}.agt_astconsv_dubil_rela_h partition for ('icmsf1')
where 0=1
;

create table ${iml_schema}.agt_astconsv_dubil_rela_h_icmsf1_op nologging
compress ${option_switch} for query high
as
select * from ${iml_schema}.agt_astconsv_dubil_rela_h partition for ('icmsf1') where 0=1;

create table ${iml_schema}.agt_astconsv_dubil_rela_h_icmsf1_cl nologging
compress ${option_switch} for query high
as
select * from ${iml_schema}.agt_astconsv_dubil_rela_h partition for ('icmsf1') where 0=1;

-- 3.1 get new data into table
-- icms_ap_afterloan_relative-1
insert into ${iml_schema}.agt_astconsv_dubil_rela_h_icmsf1_tm(
    appl_id -- 申请编号
    ,lp_id -- 法人编号
    ,flow_num -- 流水号
    ,rela_flow_num -- 关联流水号
    ,bus_type_cd -- 业务类型代码
    ,ths_tm_asset_cls_cd -- 本次资产分类代码
    ,aldy_cmplt_flg -- 已完善标志
    ,disp_plan_and_prog_descb -- 处置计划及进展描述
    ,on_acct_seq_num -- 挂账序号
    ,derate_bf_pric_tot -- 减免前本金汇总
    ,derate_pric -- 减免本金
    ,derate_provi_comp_int -- 减免计提复利
    ,derate_provi_int -- 减免计提利息
    ,derate_provi_pnlt -- 减免计提罚息
    ,derate_ovdue_pric -- 减免逾期本金
    ,derate_int_rat -- 减免利率
    ,derate_actl_owe_comp_int -- 减免实欠复利
    ,derate_actl_owe_int -- 减免实欠利息
    ,derate_actl_owe_pnlt -- 减免实欠罚息
    ,accti_status_cd -- 核算状态代码
    ,last_asset_cls_cd -- 上一资产分类代码
    ,asset_descb -- 资产线索描述
    ,core_sucs_return_rest_flg -- 核心成功返回结果标志
    ,core_return_rest -- 核心返回结果
    ,ths_return_post_acct_recl_amt -- 本次回款后应收款金额
    ,ths_return_bf_acct_recv_amt -- 本次回款前应收款金额
    ,acm_return_amt -- 累计回款金额
    ,revs_status_cd -- 冲正状态代码
    ,assign_tran_price -- 分配转让价格
    ,assign_tran_fst_price -- 分配转让首期价格
    ,assign_tran_acct_recvbl_price -- 分配转让应收款价格
    ,wrt_off_adv_fee -- 核销代垫费用
    ,suit_prog_descb -- 诉讼进展描述
    ,rgst_dt -- 登记日期
    ,rgst_belong_org_id -- 登记所属机构编号
    ,rgst_teller_id -- 登记柜员编号
    ,update_teller_id -- 更新柜员编号
    ,update_org_id -- 更新机构编号
    ,remark -- 备注
    ,etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
)
select
    '206008'||P1.SERIALNO -- 申请编号
    ,'9999' -- 法人编号
    ,P1.SERIALNO -- 流水号
    ,P1.RELSERIALNO -- 关联流水号
    ,nvl(trim(P1.OBJECTTYPE),'-') -- 业务类型代码
    ,decode(P1.CLASSIFY,'01','A','02','B','03','C',' ','-',P1.CLASSIFY) -- 本次资产分类代码
    ,nvl(trim(P1.COMPLETEFLAG),'-') -- 已完善标志
    ,P1.DISPOSALPLAN -- 处置计划及进展描述
    ,P1.HANGSEQNO -- 挂账序号
    ,P1.BALANCE -- 减免前本金汇总
    ,P1.LFBUSINESSSUM -- 减免本金
    ,P1.LFJTCOMPOUNDINTRATIO -- 减免计提复利
    ,P1.LFJTINTAMT -- 减免计提利息
    ,to_number(nvl(trim(P1.LFJTODPAMT),0)) -- 减免计提罚息
    ,P1.LFOVERDUEBALANCE -- 减免逾期本金
    ,P1.LFSERATE -- 减免利率
    ,P1.LFSJCOMPOUNDINTRATIO -- 减免实欠复利
    ,P1.LFSJINTAMT -- 减免实欠利息
    ,P1.LFSQODPAMT -- 减免实欠罚息
    ,nvl(trim(P1.LOANSTATUS),'-') -- 核算状态代码
    ,decode(P1.OLDCLASSIFY,'01','A','02','B','03','C',' ','-',P1.OLDCLASSIFY) -- 上一资产分类代码
    ,P1.PROPERTYCLUE -- 资产线索描述
    ,decode(P1.RESPONSECODE,'1','1','2','0',' ','-',P1.RESPONSECODE) -- 核心成功返回结果标志
    ,P1.RESPONSEMESSAGE -- 核心返回结果
    ,P1.RETURNEDAFTERMONEY -- 本次回款后应收款金额
    ,P1.RETURNEDBEFOREMONEY -- 本次回款前应收款金额
    ,P1.RETURNEDMONEYSUM -- 累计回款金额
    ,nvl(trim(P1.REVERSAL),'-') -- 冲正状态代码
    ,P1.TRANSFERPRICE -- 分配转让价格
    ,P1.TRANSFERSQPRICE -- 分配转让首期价格
    ,P1.TRANSFERYSKPRICE -- 分配转让应收款价格
    ,P1.WRNDDFYAMT -- 核销代垫费用
    ,P1.SSJZ -- 诉讼进展描述
    ,P1.INPUTDATE -- 登记日期
    ,P1.INPUTORGID -- 登记所属机构编号
    ,P1.INPUTUSERID -- 登记柜员编号
    ,P1.UPDATEORGID -- 更新柜员编号
    ,P1.UPDATEUSERID -- 更新机构编号
    ,P1.REMARK -- 备注
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,'icms_ap_afterloan_relative' -- 源表名称
    ,'icmsf1' -- 任务编码
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间戳
from ${iol_schema}.icms_ap_afterloan_relative p1
where p1.start_dt <= to_date('${batch_date}','yyyymmdd') and p1.end_dt > to_date('${batch_date}','yyyymmdd')
;
commit;


commit;

whenever sqlerror exit sql.sqlcode;
declare
cnt integer;
begin
  for cur in (select 1 from dual) loop
  	select count(1) into cnt from (select 1 from ${iml_schema}.agt_astconsv_dubil_rela_h_icmsf1_tm 
  	                                group by 
  	                                        appl_id
  	                                        ,lp_id
  	                                        ,flow_num
  	                                        ,rela_flow_num
  	                                        ,bus_type_cd
  	                               having count(1) > 1);
    if cnt = 0 
      then
        continue;
      else
        raise_application_error(-20001,'primary key is duplication');
    end if;
  end loop;
end;
/


-- 3.2 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iml_schema}.agt_astconsv_dubil_rela_h_icmsf1_cl(
            appl_id -- 申请编号
    ,lp_id -- 法人编号
    ,flow_num -- 流水号
    ,rela_flow_num -- 关联流水号
    ,bus_type_cd -- 业务类型代码
    ,ths_tm_asset_cls_cd -- 本次资产分类代码
    ,aldy_cmplt_flg -- 已完善标志
    ,disp_plan_and_prog_descb -- 处置计划及进展描述
    ,on_acct_seq_num -- 挂账序号
    ,derate_bf_pric_tot -- 减免前本金汇总
    ,derate_pric -- 减免本金
    ,derate_provi_comp_int -- 减免计提复利
    ,derate_provi_int -- 减免计提利息
    ,derate_provi_pnlt -- 减免计提罚息
    ,derate_ovdue_pric -- 减免逾期本金
    ,derate_int_rat -- 减免利率
    ,derate_actl_owe_comp_int -- 减免实欠复利
    ,derate_actl_owe_int -- 减免实欠利息
    ,derate_actl_owe_pnlt -- 减免实欠罚息
    ,accti_status_cd -- 核算状态代码
    ,last_asset_cls_cd -- 上一资产分类代码
    ,asset_descb -- 资产线索描述
    ,core_sucs_return_rest_flg -- 核心成功返回结果标志
    ,core_return_rest -- 核心返回结果
    ,ths_return_post_acct_recl_amt -- 本次回款后应收款金额
    ,ths_return_bf_acct_recv_amt -- 本次回款前应收款金额
    ,acm_return_amt -- 累计回款金额
    ,revs_status_cd -- 冲正状态代码
    ,assign_tran_price -- 分配转让价格
    ,assign_tran_fst_price -- 分配转让首期价格
    ,assign_tran_acct_recvbl_price -- 分配转让应收款价格
    ,wrt_off_adv_fee -- 核销代垫费用
    ,suit_prog_descb -- 诉讼进展描述
    ,rgst_dt -- 登记日期
    ,rgst_belong_org_id -- 登记所属机构编号
    ,rgst_teller_id -- 登记柜员编号
    ,update_teller_id -- 更新柜员编号
    ,update_org_id -- 更新机构编号
    ,remark -- 备注
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,src_table_name -- 源表名称
            ,job_cd -- 任务编码
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iml_schema}.agt_astconsv_dubil_rela_h_icmsf1_op(
            appl_id -- 申请编号
    ,lp_id -- 法人编号
    ,flow_num -- 流水号
    ,rela_flow_num -- 关联流水号
    ,bus_type_cd -- 业务类型代码
    ,ths_tm_asset_cls_cd -- 本次资产分类代码
    ,aldy_cmplt_flg -- 已完善标志
    ,disp_plan_and_prog_descb -- 处置计划及进展描述
    ,on_acct_seq_num -- 挂账序号
    ,derate_bf_pric_tot -- 减免前本金汇总
    ,derate_pric -- 减免本金
    ,derate_provi_comp_int -- 减免计提复利
    ,derate_provi_int -- 减免计提利息
    ,derate_provi_pnlt -- 减免计提罚息
    ,derate_ovdue_pric -- 减免逾期本金
    ,derate_int_rat -- 减免利率
    ,derate_actl_owe_comp_int -- 减免实欠复利
    ,derate_actl_owe_int -- 减免实欠利息
    ,derate_actl_owe_pnlt -- 减免实欠罚息
    ,accti_status_cd -- 核算状态代码
    ,last_asset_cls_cd -- 上一资产分类代码
    ,asset_descb -- 资产线索描述
    ,core_sucs_return_rest_flg -- 核心成功返回结果标志
    ,core_return_rest -- 核心返回结果
    ,ths_return_post_acct_recl_amt -- 本次回款后应收款金额
    ,ths_return_bf_acct_recv_amt -- 本次回款前应收款金额
    ,acm_return_amt -- 累计回款金额
    ,revs_status_cd -- 冲正状态代码
    ,assign_tran_price -- 分配转让价格
    ,assign_tran_fst_price -- 分配转让首期价格
    ,assign_tran_acct_recvbl_price -- 分配转让应收款价格
    ,wrt_off_adv_fee -- 核销代垫费用
    ,suit_prog_descb -- 诉讼进展描述
    ,rgst_dt -- 登记日期
    ,rgst_belong_org_id -- 登记所属机构编号
    ,rgst_teller_id -- 登记柜员编号
    ,update_teller_id -- 更新柜员编号
    ,update_org_id -- 更新机构编号
    ,remark -- 备注
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,src_table_name -- 源表名称
            ,job_cd -- 任务编码
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.appl_id, o.appl_id) as appl_id -- 申请编号
    ,nvl(n.lp_id, o.lp_id) as lp_id -- 法人编号
    ,nvl(n.flow_num, o.flow_num) as flow_num -- 流水号
    ,nvl(n.rela_flow_num, o.rela_flow_num) as rela_flow_num -- 关联流水号
    ,nvl(n.bus_type_cd, o.bus_type_cd) as bus_type_cd -- 业务类型代码
    ,nvl(n.ths_tm_asset_cls_cd, o.ths_tm_asset_cls_cd) as ths_tm_asset_cls_cd -- 本次资产分类代码
    ,nvl(n.aldy_cmplt_flg, o.aldy_cmplt_flg) as aldy_cmplt_flg -- 已完善标志
    ,nvl(n.disp_plan_and_prog_descb, o.disp_plan_and_prog_descb) as disp_plan_and_prog_descb -- 处置计划及进展描述
    ,nvl(n.on_acct_seq_num, o.on_acct_seq_num) as on_acct_seq_num -- 挂账序号
    ,nvl(n.derate_bf_pric_tot, o.derate_bf_pric_tot) as derate_bf_pric_tot -- 减免前本金汇总
    ,nvl(n.derate_pric, o.derate_pric) as derate_pric -- 减免本金
    ,nvl(n.derate_provi_comp_int, o.derate_provi_comp_int) as derate_provi_comp_int -- 减免计提复利
    ,nvl(n.derate_provi_int, o.derate_provi_int) as derate_provi_int -- 减免计提利息
    ,nvl(n.derate_provi_pnlt, o.derate_provi_pnlt) as derate_provi_pnlt -- 减免计提罚息
    ,nvl(n.derate_ovdue_pric, o.derate_ovdue_pric) as derate_ovdue_pric -- 减免逾期本金
    ,nvl(n.derate_int_rat, o.derate_int_rat) as derate_int_rat -- 减免利率
    ,nvl(n.derate_actl_owe_comp_int, o.derate_actl_owe_comp_int) as derate_actl_owe_comp_int -- 减免实欠复利
    ,nvl(n.derate_actl_owe_int, o.derate_actl_owe_int) as derate_actl_owe_int -- 减免实欠利息
    ,nvl(n.derate_actl_owe_pnlt, o.derate_actl_owe_pnlt) as derate_actl_owe_pnlt -- 减免实欠罚息
    ,nvl(n.accti_status_cd, o.accti_status_cd) as accti_status_cd -- 核算状态代码
    ,nvl(n.last_asset_cls_cd, o.last_asset_cls_cd) as last_asset_cls_cd -- 上一资产分类代码
    ,nvl(n.asset_descb, o.asset_descb) as asset_descb -- 资产线索描述
    ,nvl(n.core_sucs_return_rest_flg, o.core_sucs_return_rest_flg) as core_sucs_return_rest_flg -- 核心成功返回结果标志
    ,nvl(n.core_return_rest, o.core_return_rest) as core_return_rest -- 核心返回结果
    ,nvl(n.ths_return_post_acct_recl_amt, o.ths_return_post_acct_recl_amt) as ths_return_post_acct_recl_amt -- 本次回款后应收款金额
    ,nvl(n.ths_return_bf_acct_recv_amt, o.ths_return_bf_acct_recv_amt) as ths_return_bf_acct_recv_amt -- 本次回款前应收款金额
    ,nvl(n.acm_return_amt, o.acm_return_amt) as acm_return_amt -- 累计回款金额
    ,nvl(n.revs_status_cd, o.revs_status_cd) as revs_status_cd -- 冲正状态代码
    ,nvl(n.assign_tran_price, o.assign_tran_price) as assign_tran_price -- 分配转让价格
    ,nvl(n.assign_tran_fst_price, o.assign_tran_fst_price) as assign_tran_fst_price -- 分配转让首期价格
    ,nvl(n.assign_tran_acct_recvbl_price, o.assign_tran_acct_recvbl_price) as assign_tran_acct_recvbl_price -- 分配转让应收款价格
    ,nvl(n.wrt_off_adv_fee, o.wrt_off_adv_fee) as wrt_off_adv_fee -- 核销代垫费用
    ,nvl(n.suit_prog_descb, o.suit_prog_descb) as suit_prog_descb -- 诉讼进展描述
    ,nvl(n.rgst_dt, o.rgst_dt) as rgst_dt -- 登记日期
    ,nvl(n.rgst_belong_org_id, o.rgst_belong_org_id) as rgst_belong_org_id -- 登记所属机构编号
    ,nvl(n.rgst_teller_id, o.rgst_teller_id) as rgst_teller_id -- 登记柜员编号
    ,nvl(n.update_teller_id, o.update_teller_id) as update_teller_id -- 更新柜员编号
    ,nvl(n.update_org_id, o.update_org_id) as update_org_id -- 更新机构编号
    ,nvl(n.remark, o.remark) as remark -- 备注
    ,case when
            n.appl_id is null
            and n.lp_id is null
            and n.flow_num is null
            and n.rela_flow_num is null
            and n.bus_type_cd is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.appl_id is null
            and n.lp_id is null
            and n.flow_num is null
            and n.rela_flow_num is null
            and n.bus_type_cd is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.appl_id is null
            and n.lp_id is null
            and n.flow_num is null
            and n.rela_flow_num is null
            and n.bus_type_cd is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,nvl(n.src_table_name, o.src_table_name) as src_table_name -- 源表名称
    ,nvl(n.job_cd, o.job_cd) as job_cd -- 任务编码
    ,nvl(n.etl_timestamp, o.etl_timestamp) as etl_timestamp -- ETL处理时间戳
from ${iml_schema}.agt_astconsv_dubil_rela_h_icmsf1_tm n
    full join (select * from ${iml_schema}.agt_astconsv_dubil_rela_h_icmsf1_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
        on
            o.appl_id = n.appl_id
            and o.lp_id = n.lp_id
            and o.flow_num = n.flow_num
            and o.rela_flow_num = n.rela_flow_num
            and o.bus_type_cd = n.bus_type_cd
where (
        o.appl_id is null
        and o.lp_id is null
        and o.flow_num is null
        and o.rela_flow_num is null
        and o.bus_type_cd is null
    )
    or (
        n.appl_id is null
        and n.lp_id is null
        and n.flow_num is null
        and n.rela_flow_num is null
        and n.bus_type_cd is null
    )
    or (
        o.ths_tm_asset_cls_cd <> n.ths_tm_asset_cls_cd
        or o.aldy_cmplt_flg <> n.aldy_cmplt_flg
        or o.disp_plan_and_prog_descb <> n.disp_plan_and_prog_descb
        or o.on_acct_seq_num <> n.on_acct_seq_num
        or o.derate_bf_pric_tot <> n.derate_bf_pric_tot
        or o.derate_pric <> n.derate_pric
        or o.derate_provi_comp_int <> n.derate_provi_comp_int
        or o.derate_provi_int <> n.derate_provi_int
        or o.derate_provi_pnlt <> n.derate_provi_pnlt
        or o.derate_ovdue_pric <> n.derate_ovdue_pric
        or o.derate_int_rat <> n.derate_int_rat
        or o.derate_actl_owe_comp_int <> n.derate_actl_owe_comp_int
        or o.derate_actl_owe_int <> n.derate_actl_owe_int
        or o.derate_actl_owe_pnlt <> n.derate_actl_owe_pnlt
        or o.accti_status_cd <> n.accti_status_cd
        or o.last_asset_cls_cd <> n.last_asset_cls_cd
        or o.asset_descb <> n.asset_descb
        or o.core_sucs_return_rest_flg <> n.core_sucs_return_rest_flg
        or o.core_return_rest <> n.core_return_rest
        or o.ths_return_post_acct_recl_amt <> n.ths_return_post_acct_recl_amt
        or o.ths_return_bf_acct_recv_amt <> n.ths_return_bf_acct_recv_amt
        or o.acm_return_amt <> n.acm_return_amt
        or o.revs_status_cd <> n.revs_status_cd
        or o.assign_tran_price <> n.assign_tran_price
        or o.assign_tran_fst_price <> n.assign_tran_fst_price
        or o.assign_tran_acct_recvbl_price <> n.assign_tran_acct_recvbl_price
        or o.wrt_off_adv_fee <> n.wrt_off_adv_fee
        or o.suit_prog_descb <> n.suit_prog_descb
        or o.rgst_dt <> n.rgst_dt
        or o.rgst_belong_org_id <> n.rgst_belong_org_id
        or o.rgst_teller_id <> n.rgst_teller_id
        or o.update_teller_id <> n.update_teller_id
        or o.update_org_id <> n.update_org_id
        or o.remark <> n.remark
    )
;
commit;

-- 3.3 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iml_schema}.agt_astconsv_dubil_rela_h_icmsf1_cl(
            appl_id -- 申请编号
    ,lp_id -- 法人编号
    ,flow_num -- 流水号
    ,rela_flow_num -- 关联流水号
    ,bus_type_cd -- 业务类型代码
    ,ths_tm_asset_cls_cd -- 本次资产分类代码
    ,aldy_cmplt_flg -- 已完善标志
    ,disp_plan_and_prog_descb -- 处置计划及进展描述
    ,on_acct_seq_num -- 挂账序号
    ,derate_bf_pric_tot -- 减免前本金汇总
    ,derate_pric -- 减免本金
    ,derate_provi_comp_int -- 减免计提复利
    ,derate_provi_int -- 减免计提利息
    ,derate_provi_pnlt -- 减免计提罚息
    ,derate_ovdue_pric -- 减免逾期本金
    ,derate_int_rat -- 减免利率
    ,derate_actl_owe_comp_int -- 减免实欠复利
    ,derate_actl_owe_int -- 减免实欠利息
    ,derate_actl_owe_pnlt -- 减免实欠罚息
    ,accti_status_cd -- 核算状态代码
    ,last_asset_cls_cd -- 上一资产分类代码
    ,asset_descb -- 资产线索描述
    ,core_sucs_return_rest_flg -- 核心成功返回结果标志
    ,core_return_rest -- 核心返回结果
    ,ths_return_post_acct_recl_amt -- 本次回款后应收款金额
    ,ths_return_bf_acct_recv_amt -- 本次回款前应收款金额
    ,acm_return_amt -- 累计回款金额
    ,revs_status_cd -- 冲正状态代码
    ,assign_tran_price -- 分配转让价格
    ,assign_tran_fst_price -- 分配转让首期价格
    ,assign_tran_acct_recvbl_price -- 分配转让应收款价格
    ,wrt_off_adv_fee -- 核销代垫费用
    ,suit_prog_descb -- 诉讼进展描述
    ,rgst_dt -- 登记日期
    ,rgst_belong_org_id -- 登记所属机构编号
    ,rgst_teller_id -- 登记柜员编号
    ,update_teller_id -- 更新柜员编号
    ,update_org_id -- 更新机构编号
    ,remark -- 备注
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,src_table_name -- 源表名称
            ,job_cd -- 任务编码
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iml_schema}.agt_astconsv_dubil_rela_h_icmsf1_op(
            appl_id -- 申请编号
    ,lp_id -- 法人编号
    ,flow_num -- 流水号
    ,rela_flow_num -- 关联流水号
    ,bus_type_cd -- 业务类型代码
    ,ths_tm_asset_cls_cd -- 本次资产分类代码
    ,aldy_cmplt_flg -- 已完善标志
    ,disp_plan_and_prog_descb -- 处置计划及进展描述
    ,on_acct_seq_num -- 挂账序号
    ,derate_bf_pric_tot -- 减免前本金汇总
    ,derate_pric -- 减免本金
    ,derate_provi_comp_int -- 减免计提复利
    ,derate_provi_int -- 减免计提利息
    ,derate_provi_pnlt -- 减免计提罚息
    ,derate_ovdue_pric -- 减免逾期本金
    ,derate_int_rat -- 减免利率
    ,derate_actl_owe_comp_int -- 减免实欠复利
    ,derate_actl_owe_int -- 减免实欠利息
    ,derate_actl_owe_pnlt -- 减免实欠罚息
    ,accti_status_cd -- 核算状态代码
    ,last_asset_cls_cd -- 上一资产分类代码
    ,asset_descb -- 资产线索描述
    ,core_sucs_return_rest_flg -- 核心成功返回结果标志
    ,core_return_rest -- 核心返回结果
    ,ths_return_post_acct_recl_amt -- 本次回款后应收款金额
    ,ths_return_bf_acct_recv_amt -- 本次回款前应收款金额
    ,acm_return_amt -- 累计回款金额
    ,revs_status_cd -- 冲正状态代码
    ,assign_tran_price -- 分配转让价格
    ,assign_tran_fst_price -- 分配转让首期价格
    ,assign_tran_acct_recvbl_price -- 分配转让应收款价格
    ,wrt_off_adv_fee -- 核销代垫费用
    ,suit_prog_descb -- 诉讼进展描述
    ,rgst_dt -- 登记日期
    ,rgst_belong_org_id -- 登记所属机构编号
    ,rgst_teller_id -- 登记柜员编号
    ,update_teller_id -- 更新柜员编号
    ,update_org_id -- 更新机构编号
    ,remark -- 备注
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,src_table_name -- 源表名称
            ,job_cd -- 任务编码
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.appl_id -- 申请编号
    ,o.lp_id -- 法人编号
    ,o.flow_num -- 流水号
    ,o.rela_flow_num -- 关联流水号
    ,o.bus_type_cd -- 业务类型代码
    ,o.ths_tm_asset_cls_cd -- 本次资产分类代码
    ,o.aldy_cmplt_flg -- 已完善标志
    ,o.disp_plan_and_prog_descb -- 处置计划及进展描述
    ,o.on_acct_seq_num -- 挂账序号
    ,o.derate_bf_pric_tot -- 减免前本金汇总
    ,o.derate_pric -- 减免本金
    ,o.derate_provi_comp_int -- 减免计提复利
    ,o.derate_provi_int -- 减免计提利息
    ,o.derate_provi_pnlt -- 减免计提罚息
    ,o.derate_ovdue_pric -- 减免逾期本金
    ,o.derate_int_rat -- 减免利率
    ,o.derate_actl_owe_comp_int -- 减免实欠复利
    ,o.derate_actl_owe_int -- 减免实欠利息
    ,o.derate_actl_owe_pnlt -- 减免实欠罚息
    ,o.accti_status_cd -- 核算状态代码
    ,o.last_asset_cls_cd -- 上一资产分类代码
    ,o.asset_descb -- 资产线索描述
    ,o.core_sucs_return_rest_flg -- 核心成功返回结果标志
    ,o.core_return_rest -- 核心返回结果
    ,o.ths_return_post_acct_recl_amt -- 本次回款后应收款金额
    ,o.ths_return_bf_acct_recv_amt -- 本次回款前应收款金额
    ,o.acm_return_amt -- 累计回款金额
    ,o.revs_status_cd -- 冲正状态代码
    ,o.assign_tran_price -- 分配转让价格
    ,o.assign_tran_fst_price -- 分配转让首期价格
    ,o.assign_tran_acct_recvbl_price -- 分配转让应收款价格
    ,o.wrt_off_adv_fee -- 核销代垫费用
    ,o.suit_prog_descb -- 诉讼进展描述
    ,o.rgst_dt -- 登记日期
    ,o.rgst_belong_org_id -- 登记所属机构编号
    ,o.rgst_teller_id -- 登记柜员编号
    ,o.update_teller_id -- 更新柜员编号
    ,o.update_org_id -- 更新机构编号
    ,o.remark -- 备注
    ,o.start_dt -- 开始时间
    ,case when n.start_dt is not null then to_date('${batch_date}', 'yyyymmdd')
          when o.end_dt >= to_date('${batch_date}','yyyymmdd') then to_date('20991231','yyyymmdd')
          else o.end_dt
     end as end_dt -- 结束时间
    , case when n.start_dt is not null
          then 'I'
          when o.end_dt >= to_date('${batch_date}','yyyymmdd')
          then 'I'
          else o.id_mark
     end as id_mark  -- 增删标志 
    ,o.src_table_name -- 源表名称
    ,o.job_cd -- 任务编码
    ,o.etl_timestamp -- ETL处理时间戳
from ${iml_schema}.agt_astconsv_dubil_rela_h_icmsf1_bk o
    left join ${iml_schema}.agt_astconsv_dubil_rela_h_icmsf1_op n
        on
            o.appl_id = n.appl_id
            and o.lp_id = n.lp_id
            and o.flow_num = n.flow_num
            and o.rela_flow_num = n.rela_flow_num
            and o.bus_type_cd = n.bus_type_cd
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iml_schema}.agt_astconsv_dubil_rela_h_icmsf1_cl d
        on
            o.appl_id = d.appl_id
            and o.lp_id = d.lp_id
            and o.flow_num = d.flow_num
            and o.rela_flow_num = d.rela_flow_num
            and o.bus_type_cd = d.bus_type_cd
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;
-- 4.1 truncate target table
--truncate table ${iml_schema}.agt_astconsv_dubil_rela_h;
--alter table ${iml_schema}.agt_astconsv_dubil_rela_h truncate partition for ('icmsf1') reuse storage;

-- 4.2 rebuild partition
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
declare
v_sql varchar2(100);
begin
for cur in (select subpartition_name 
              from all_tab_subpartitions 
             where table_owner=upper('${iml_schema}') 
               and table_name=upper('agt_astconsv_dubil_rela_h') 
               and substr(subpartition_name,1,8)=upper('p_icmsf1')
               and substr(subpartition_name,10) >= '${batch_date}' 
               and substr(subpartition_name,10) < '20991231') loop
    v_sql := 'alter table ${iml_schema}.agt_astconsv_dubil_rela_h drop subpartition ' || cur.subpartition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/

whenever sqlerror exit sql.sqlcode;
alter table ${iml_schema}.agt_astconsv_dubil_rela_h modify partition p_icmsf1 
add subpartition p_icmsf1_${batch_date} values(to_date('${batch_date}','YYYYMMDD')) ;

-- 4.3 exchange partition
alter table ${iml_schema}.agt_astconsv_dubil_rela_h exchange subpartition p_icmsf1_${batch_date} with table ${iml_schema}.agt_astconsv_dubil_rela_h_icmsf1_cl;
alter table ${iml_schema}.agt_astconsv_dubil_rela_h exchange subpartition p_icmsf1_20991231 with table ${iml_schema}.agt_astconsv_dubil_rela_h_icmsf1_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iml_schema}.agt_astconsv_dubil_rela_h to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iml_schema}.agt_astconsv_dubil_rela_h_icmsf1_tm purge;
drop table ${iml_schema}.agt_astconsv_dubil_rela_h_icmsf1_op purge;
drop table ${iml_schema}.agt_astconsv_dubil_rela_h_icmsf1_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iml_schema}.agt_astconsv_dubil_rela_h_icmsf1_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iml_schema}',tabname => 'agt_astconsv_dubil_rela_h', partname => 'p_icmsf1_20991231',ESTIMATE_PERCENT=>10, method_opt=>'for all columns size 1',no_invalidate=>false, force=>true, granularity => 'SUBPARTITION', degree => 8, cascade => true);
