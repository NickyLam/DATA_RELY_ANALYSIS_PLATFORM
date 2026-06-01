/*
Purpose:    整全模型层-快照表脚本，备份目标表当月数据（不含当天），用前一天数据与当天数据整合后插入到目标表中。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iml_agt_cap_asset_bal_ctmsf1
CreateDate: 20180515
Logs:
    zjj 2018-05-15 新建表本
*/

set timing on

-- 1 alter parallel
alter session force parallel query parallel 4;
alter session force parallel dml parallel 4;
-- alter session force parallel ddl parallel 1;

-- 2.1 create table for exchage and add partition
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iml_schema}.agt_cap_asset_bal_ctmsf1_tm purge;
drop table ${iml_schema}.agt_cap_asset_bal_ctmsf1_ex purge;

-- 2.2 add partition for target table
alter table ${iml_schema}.agt_cap_asset_bal add partition p_ctmsf1 values ('ctmsf1')(
        subpartition p_ctmsf1_${batch_date} values (to_date('${batch_date}','yyyymmdd'))
    )
;
alter table ${iml_schema}.agt_cap_asset_bal modify partition p_ctmsf1
    add subpartition p_ctmsf1_${batch_date} values (to_date('${batch_date}','yyyymmdd'))
;

-- 2.3 if backup table is exists, mean script if failed on last time
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
create table ${iml_schema}.agt_cap_asset_bal_ctmsf1_bk nologging
compress ${option_switch} for query high
as
select * from ${iml_schema}.agt_cap_asset_bal partition for ('ctmsf1')
where create_dt < to_date('${batch_date}','yyyymmdd')
;

-- 2.4 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.agt_cap_asset_bal_ctmsf1_tm
compress ${option_switch} for query high
as
select
    asset_bal_id -- 资产余额编号
    ,lp_id -- 法人编号
    ,agt_id -- 协议编号
    ,bus_id -- 业务编号
    ,bus_table_name -- 业务表名称
    ,bal_dtl_id -- 余额明细编号
    ,dept_id -- 部门编号
    ,acct_b_id -- 账簿编号
    ,stl_dt -- 结算日期
    ,asset_type_name -- 资产类型名称
    ,bus_cate_name -- 业务类别名称
    ,main_asset_id -- 主资产编号
    ,minor_asset_id -- 次资产编号
    ,std_prod_id -- 标准产品编号
    ,hold_pos -- 持有仓位
    ,hold_denom -- 持有面额
    ,net_price_cost -- 净价成本
    ,int_adj -- 利息调整
    ,evha_val_chag -- 公允价值变动
    ,int_cost -- 利息成本
    ,full_price_cost -- 全价成本
    ,impam_prep -- 减值准备
    ,spd_prft -- 价差收益
    ,amort_prft -- 摊销收益
    ,int_prft -- 利息收益
    ,evha_val_chag_pl -- 公允价值变动损益
    ,impam_loss -- 减值损失
    ,tran_fee -- 交易费用
    ,actl_int_rat -- 实际利率
    ,value_dt -- 起息日期
    ,exp_dt -- 到期日期
    ,happ_amt -- 发生金额
    ,init_asset_bal_id -- 原资产余额编号
    ,strk_bal_flg -- 冲账标志
    ,asset_thd_cls_cd -- 资产三分类代码
    ,comm_fee_inco -- 手续费收入
    ,comm_fee_expns -- 手续费支出
    ,pric_subj_id -- 本金科目编号
    ,int_cost_subj_id -- 利息成本科目编号
    ,int_adj_subj_id -- 利息调整科目编号
    ,evha_val_chag_subj_id -- 公允价值变动科目编号
    ,int_income_subj_id -- 利息收入科目编号
    ,amort_prft_subj_id -- 摊销收益科目编号
    ,evha_val_chag_pl_subj_id -- 公允价值变动损益科目编号
    ,spd_prft_subj_id -- 价差收益科目编号
    ,on_acct_amt -- 挂账金额
    ,on_acct_subj_id -- 挂账科目编号
    ,etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
from ${iml_schema}.agt_cap_asset_bal
where 0=1;

-- 2.5 create temp table
create table ${iml_schema}.agt_cap_asset_bal_ctmsf1_ex nologging
compress ${option_switch} for query high
as select * from ${iml_schema}.agt_cap_asset_bal partition for ('ctmsf1') where 0=1;

-- 2.1 insert data to tm table
-- ctms_tbs_v_new_balance-
insert into ${iml_schema}.agt_cap_asset_bal_ctmsf1_tm(
    asset_bal_id -- 资产余额编号
    ,lp_id -- 法人编号
    ,agt_id -- 协议编号
    ,bus_id -- 业务编号
    ,bus_table_name -- 业务表名称
    ,bal_dtl_id -- 余额明细编号
    ,dept_id -- 部门编号
    ,acct_b_id -- 账簿编号
    ,stl_dt -- 结算日期
    ,asset_type_name -- 资产类型名称
    ,bus_cate_name -- 业务类别名称
    ,main_asset_id -- 主资产编号
    ,minor_asset_id -- 次资产编号
    ,std_prod_id -- 标准产品编号
    ,hold_pos -- 持有仓位
    ,hold_denom -- 持有面额
    ,net_price_cost -- 净价成本
    ,int_adj -- 利息调整
    ,evha_val_chag -- 公允价值变动
    ,int_cost -- 利息成本
    ,full_price_cost -- 全价成本
    ,impam_prep -- 减值准备
    ,spd_prft -- 价差收益
    ,amort_prft -- 摊销收益
    ,int_prft -- 利息收益
    ,evha_val_chag_pl -- 公允价值变动损益
    ,impam_loss -- 减值损失
    ,tran_fee -- 交易费用
    ,actl_int_rat -- 实际利率
    ,value_dt -- 起息日期
    ,exp_dt -- 到期日期
    ,happ_amt -- 发生金额
    ,init_asset_bal_id -- 原资产余额编号
    ,strk_bal_flg -- 冲账标志
    ,asset_thd_cls_cd -- 资产三分类代码
    ,comm_fee_inco -- 手续费收入
    ,comm_fee_expns -- 手续费支出
    ,pric_subj_id -- 本金科目编号
    ,int_cost_subj_id -- 利息成本科目编号
    ,int_adj_subj_id -- 利息调整科目编号
    ,evha_val_chag_subj_id -- 公允价值变动科目编号
    ,int_income_subj_id -- 利息收入科目编号
    ,amort_prft_subj_id -- 摊销收益科目编号
    ,evha_val_chag_pl_subj_id -- 公允价值变动损益科目编号
    ,spd_prft_subj_id -- 价差收益科目编号
    ,on_acct_amt -- 挂账金额
    ,on_acct_subj_id -- 挂账科目编号
    ,etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
)
select
    TO_CHAR(P1.BALANCE_ID) -- 资产余额编号
    ,'9999' -- 法人编号
    ,CASE
         WHEN P1.ASSETTYPE = '买断式回购' THEN
          '225104' || SUBSTR(P1.MINORASSETCODE, 4)
         WHEN P1.ASSETTYPE = '质押式回购' THEN
          '225102' || SUBSTR(P1.MINORASSETCODE, 4)
         WHEN P1.ASSETTYPE = '债券借贷' THEN
          '225105' || SUBSTR(P1.MINORASSETCODE, 4)
         WHEN P1.ASSETTYPE = '拆借' THEN
          '224101' || SUBSTR(P1.MINORASSETCODE, 4)
         WHEN P1.ASSETTYPE = '开放式回购' THEN
          '225103' || SUBSTR(P1.MINORASSETCODE, 4)
         WHEN P1.ASSETTYPE = '债券发行' THEN
          '' || SUBSTR(P1.MINORASSETCODE, 4)
         ELSE
          SUBSTR(P1.MINORASSETCODE, 4)
       END -- 协议编号
    ,TO_CHAR(P1.BARETRADE_ID) -- 业务编号
    ,P1.BARETRADENAME -- 业务表名称
    ,TO_CHAR(P1.ALTERBALANCE_ID) -- 余额明细编号
    ,TO_CHAR(P1.ASPCLIENT_ID) -- 部门编号
    ,TO_CHAR(P1.KEEPFOLDER_ID) -- 账簿编号
    ,${iml_schema}.DATEFORMAT_MAX(P1.SETTLEDATE) -- 结算日期
    ,P1.ASSETTYPE -- 资产类型名称
    ,P1.BUZTYPE -- 业务类别名称
    ,P1.MAJORASSETCODE -- 主资产编号
    ,P1.MINORASSETCODE -- 次资产编号
    ,nvl(trim(P1.PRODUCT_CODE),'') -- 标准产品编号
    ,P1.HOLDPOSITION -- 持有仓位
    ,P1.HOLDFACEAMOUNT -- 持有面额
    ,P1.CLEANPRICECOST -- 净价成本
    ,P1.INTERESTADJUST -- 利息调整
    ,P1.FAIRVALUEALTER -- 公允价值变动
    ,P1.INTERESTCOST -- 利息成本
    ,P1.DIRTYPRICECOST -- 全价成本
    ,P1.IMPAIRMENT -- 减值准备
    ,P1.PRICEEARNING -- 价差收益
    ,P1.AMORTIZEEARNING -- 摊销收益
    ,P1.INTERESTEARNING -- 利息收益
    ,P1.FAIRVALUEINCOME -- 公允价值变动损益
    ,P1.IMPAIRMENTLOST -- 减值损失
    ,P1.TRADEEXPENSE -- 交易费用
    ,P1.REALRATE -- 实际利率
    ,${iml_schema}.DATEFORMAT_MAX(P1.VALUEDATE) -- 起息日期
    ,${iml_schema}.DATEFORMAT_MAX(P1.MATURITYDATE) -- 到期日期
    ,P1.OCCURAMOUNT -- 发生金额
    ,TO_CHAR(P1.BALANCE_ID_PREV) -- 原资产余额编号
    ,P1.REV_FLAG -- 冲账标志
    ,CASE WHEN R3.TARGET_CD_VAL IS NOT NULL THEN R3.TARGET_CD_VAL ELSE '@'||P1.ASSETTYPE END -- 资产三分类代码
    ,P1.CHARGEINCOME -- 手续费收入
    ,P1.CHARGEEXPENSE -- 手续费支出
    ,P1.CAPITAL_SUBJECTID -- 本金科目编号
    ,P1.INTERESTCOST_SUBJECTID -- 利息成本科目编号
    ,P1.INTERESTADJUST_SUBJECTID -- 利息调整科目编号
    ,P1.FAIRVALUEALTER_SUBJECTID -- 公允价值变动科目编号
    ,P1.INTERESTEARNING_SUBJECTID -- 利息收入科目编号
    ,P1.AMORTIZEEARNING_SUBJECTID -- 摊销收益科目编号
    ,P1.FAIRVALUEINCOME_SUBJECTID -- 公允价值变动损益科目编号
    ,P1.PRICEEARNING_SUBJECTID -- 价差收益科目编号
    ,P1.ARVINTERESTCOST -- 挂账金额
    ,P1.ARVINTERESTCOST_SUBJECTID -- 挂账科目编号
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,'ctms_tbs_v_new_balance' -- 源表名称
    ,'ctmsf1' -- 任务编码
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间戳
from ${iol_schema}.ctms_tbs_v_new_balance p1
    left join ${iml_schema}.ref_pub_cd_map r3 on P1.ASSETTYPE = R3.SRC_CODE_VAL
      AND R3.SORC_SYS_CD= 'CTMS'
      AND R3.SRC_TAB_EN_NAME= 'CTMS_TBS_V_BALANCE'
      AND R3.SRC_FIELD_EN_NAME= 'ASSETTYPE'
      AND R3.TARGET_TAB_EN_NAME= 'AGT_CAP_ASSET_BAL'
      AND R3.TARGET_TAB_FIELD_EN_NAME= 'ASSET_THD_CLS_CD'
where p1.start_dt <= to_date('${batch_date}','yyyymmdd') and p1.end_dt > to_date('${batch_date}','yyyymmdd')
;
commit;


commit;



whenever sqlerror exit sql.sqlcode;
declare
cnt integer;
begin
  for cur in (select 1 from dual) loop
  	select count(1) into cnt from (select 1 from ${iml_schema}.agt_cap_asset_bal_ctmsf1_tm 
  	                                group by 
  	                                        asset_bal_id
  	                                        ,lp_id
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

-- 2.2 chage data and update_dt, create_dt, etl_dt
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ into ${iml_schema}.agt_cap_asset_bal_ctmsf1_ex(
    asset_bal_id -- 资产余额编号
    ,lp_id -- 法人编号
    ,agt_id -- 协议编号
    ,bus_id -- 业务编号
    ,bus_table_name -- 业务表名称
    ,bal_dtl_id -- 余额明细编号
    ,dept_id -- 部门编号
    ,acct_b_id -- 账簿编号
    ,stl_dt -- 结算日期
    ,asset_type_name -- 资产类型名称
    ,bus_cate_name -- 业务类别名称
    ,main_asset_id -- 主资产编号
    ,minor_asset_id -- 次资产编号
    ,std_prod_id -- 标准产品编号
    ,hold_pos -- 持有仓位
    ,hold_denom -- 持有面额
    ,net_price_cost -- 净价成本
    ,int_adj -- 利息调整
    ,evha_val_chag -- 公允价值变动
    ,int_cost -- 利息成本
    ,full_price_cost -- 全价成本
    ,impam_prep -- 减值准备
    ,spd_prft -- 价差收益
    ,amort_prft -- 摊销收益
    ,int_prft -- 利息收益
    ,evha_val_chag_pl -- 公允价值变动损益
    ,impam_loss -- 减值损失
    ,tran_fee -- 交易费用
    ,actl_int_rat -- 实际利率
    ,value_dt -- 起息日期
    ,exp_dt -- 到期日期
    ,happ_amt -- 发生金额
    ,init_asset_bal_id -- 原资产余额编号
    ,strk_bal_flg -- 冲账标志
    ,asset_thd_cls_cd -- 资产三分类代码
    ,comm_fee_inco -- 手续费收入
    ,comm_fee_expns -- 手续费支出
    ,pric_subj_id -- 本金科目编号
    ,int_cost_subj_id -- 利息成本科目编号
    ,int_adj_subj_id -- 利息调整科目编号
    ,evha_val_chag_subj_id -- 公允价值变动科目编号
    ,int_income_subj_id -- 利息收入科目编号
    ,amort_prft_subj_id -- 摊销收益科目编号
    ,evha_val_chag_pl_subj_id -- 公允价值变动损益科目编号
    ,spd_prft_subj_id -- 价差收益科目编号
    ,on_acct_amt -- 挂账金额
    ,on_acct_subj_id -- 挂账科目编号
    ,create_dt -- 创建日期
    ,update_dt -- 更新日期
    ,etl_dt -- ETL处理日期
    ,id_mark -- 增删标志
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
)
select
    nvl(n.asset_bal_id, o.asset_bal_id) as asset_bal_id -- 资产余额编号
    ,nvl(n.lp_id, o.lp_id) as lp_id -- 法人编号
    ,nvl(n.agt_id, o.agt_id) as agt_id -- 协议编号
    ,nvl(n.bus_id, o.bus_id) as bus_id -- 业务编号
    ,nvl(n.bus_table_name, o.bus_table_name) as bus_table_name -- 业务表名称
    ,nvl(n.bal_dtl_id, o.bal_dtl_id) as bal_dtl_id -- 余额明细编号
    ,nvl(n.dept_id, o.dept_id) as dept_id -- 部门编号
    ,nvl(n.acct_b_id, o.acct_b_id) as acct_b_id -- 账簿编号
    ,nvl(n.stl_dt, o.stl_dt) as stl_dt -- 结算日期
    ,nvl(n.asset_type_name, o.asset_type_name) as asset_type_name -- 资产类型名称
    ,nvl(n.bus_cate_name, o.bus_cate_name) as bus_cate_name -- 业务类别名称
    ,nvl(n.main_asset_id, o.main_asset_id) as main_asset_id -- 主资产编号
    ,nvl(n.minor_asset_id, o.minor_asset_id) as minor_asset_id -- 次资产编号
    ,nvl(n.std_prod_id, o.std_prod_id) as std_prod_id -- 标准产品编号
    ,nvl(n.hold_pos, o.hold_pos) as hold_pos -- 持有仓位
    ,nvl(n.hold_denom, o.hold_denom) as hold_denom -- 持有面额
    ,nvl(n.net_price_cost, o.net_price_cost) as net_price_cost -- 净价成本
    ,nvl(n.int_adj, o.int_adj) as int_adj -- 利息调整
    ,nvl(n.evha_val_chag, o.evha_val_chag) as evha_val_chag -- 公允价值变动
    ,nvl(n.int_cost, o.int_cost) as int_cost -- 利息成本
    ,nvl(n.full_price_cost, o.full_price_cost) as full_price_cost -- 全价成本
    ,nvl(n.impam_prep, o.impam_prep) as impam_prep -- 减值准备
    ,nvl(n.spd_prft, o.spd_prft) as spd_prft -- 价差收益
    ,nvl(n.amort_prft, o.amort_prft) as amort_prft -- 摊销收益
    ,nvl(n.int_prft, o.int_prft) as int_prft -- 利息收益
    ,nvl(n.evha_val_chag_pl, o.evha_val_chag_pl) as evha_val_chag_pl -- 公允价值变动损益
    ,nvl(n.impam_loss, o.impam_loss) as impam_loss -- 减值损失
    ,nvl(n.tran_fee, o.tran_fee) as tran_fee -- 交易费用
    ,nvl(n.actl_int_rat, o.actl_int_rat) as actl_int_rat -- 实际利率
    ,nvl(n.value_dt, o.value_dt) as value_dt -- 起息日期
    ,nvl(n.exp_dt, o.exp_dt) as exp_dt -- 到期日期
    ,nvl(n.happ_amt, o.happ_amt) as happ_amt -- 发生金额
    ,nvl(n.init_asset_bal_id, o.init_asset_bal_id) as init_asset_bal_id -- 原资产余额编号
    ,nvl(n.strk_bal_flg, o.strk_bal_flg) as strk_bal_flg -- 冲账标志
    ,nvl(n.asset_thd_cls_cd, o.asset_thd_cls_cd) as asset_thd_cls_cd -- 资产三分类代码
    ,nvl(n.comm_fee_inco, o.comm_fee_inco) as comm_fee_inco -- 手续费收入
    ,nvl(n.comm_fee_expns, o.comm_fee_expns) as comm_fee_expns -- 手续费支出
    ,nvl(n.pric_subj_id, o.pric_subj_id) as pric_subj_id -- 本金科目编号
    ,nvl(n.int_cost_subj_id, o.int_cost_subj_id) as int_cost_subj_id -- 利息成本科目编号
    ,nvl(n.int_adj_subj_id, o.int_adj_subj_id) as int_adj_subj_id -- 利息调整科目编号
    ,nvl(n.evha_val_chag_subj_id, o.evha_val_chag_subj_id) as evha_val_chag_subj_id -- 公允价值变动科目编号
    ,nvl(n.int_income_subj_id, o.int_income_subj_id) as int_income_subj_id -- 利息收入科目编号
    ,nvl(n.amort_prft_subj_id, o.amort_prft_subj_id) as amort_prft_subj_id -- 摊销收益科目编号
    ,nvl(n.evha_val_chag_pl_subj_id, o.evha_val_chag_pl_subj_id) as evha_val_chag_pl_subj_id -- 公允价值变动损益科目编号
    ,nvl(n.spd_prft_subj_id, o.spd_prft_subj_id) as spd_prft_subj_id -- 价差收益科目编号
    ,nvl(n.on_acct_amt, o.on_acct_amt) as on_acct_amt -- 挂账金额
    ,nvl(n.on_acct_subj_id, o.on_acct_subj_id) as on_acct_subj_id -- 挂账科目编号
    ,nvl(o.create_dt, to_date('${batch_date}', 'yyyymmdd')) as create_dt -- 创建日期
    ,case when (
                o.asset_bal_id is null
                and o.lp_id is null
            ) or (
                o.agt_id <> n.agt_id
                or o.bus_id <> n.bus_id
                or o.bus_table_name <> n.bus_table_name
                or o.bal_dtl_id <> n.bal_dtl_id
                or o.dept_id <> n.dept_id
                or o.acct_b_id <> n.acct_b_id
                or o.stl_dt <> n.stl_dt
                or o.asset_type_name <> n.asset_type_name
                or o.bus_cate_name <> n.bus_cate_name
                or o.main_asset_id <> n.main_asset_id
                or o.minor_asset_id <> n.minor_asset_id
                or o.std_prod_id <> n.std_prod_id
                or o.hold_pos <> n.hold_pos
                or o.hold_denom <> n.hold_denom
                or o.net_price_cost <> n.net_price_cost
                or o.int_adj <> n.int_adj
                or o.evha_val_chag <> n.evha_val_chag
                or o.int_cost <> n.int_cost
                or o.full_price_cost <> n.full_price_cost
                or o.impam_prep <> n.impam_prep
                or o.spd_prft <> n.spd_prft
                or o.amort_prft <> n.amort_prft
                or o.int_prft <> n.int_prft
                or o.evha_val_chag_pl <> n.evha_val_chag_pl
                or o.impam_loss <> n.impam_loss
                or o.tran_fee <> n.tran_fee
                or o.actl_int_rat <> n.actl_int_rat
                or o.value_dt <> n.value_dt
                or o.exp_dt <> n.exp_dt
                or o.happ_amt <> n.happ_amt
                or o.init_asset_bal_id <> n.init_asset_bal_id
                or o.strk_bal_flg <> n.strk_bal_flg
                or o.asset_thd_cls_cd <> n.asset_thd_cls_cd
                or o.comm_fee_inco <> n.comm_fee_inco
                or o.comm_fee_expns <> n.comm_fee_expns
                or o.pric_subj_id <> n.pric_subj_id
                or o.int_cost_subj_id <> n.int_cost_subj_id
                or o.int_adj_subj_id <> n.int_adj_subj_id
                or o.evha_val_chag_subj_id <> n.evha_val_chag_subj_id
                or o.int_income_subj_id <> n.int_income_subj_id
                or o.amort_prft_subj_id <> n.amort_prft_subj_id
                or o.evha_val_chag_pl_subj_id <> n.evha_val_chag_pl_subj_id
                or o.spd_prft_subj_id <> n.spd_prft_subj_id
                or o.on_acct_amt <> n.on_acct_amt
                or o.on_acct_subj_id <> n.on_acct_subj_id
            ) or (
                 case when (
                           n.asset_bal_id is null
                           and n.lp_id is null
                         )
                      then 'D'
                 else 'I'
                 end
            )<> o.id_mark
        then to_date('${batch_date}', 'yyyymmdd')
        else o.update_dt
     end as update_dt -- 更新日期
    ,to_date('${batch_date}', 'yyyymmdd') as etl_dt -- ETL处理日期
    ,case when (
                n.asset_bal_id is null
                and n.lp_id is null
            )
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,nvl(n.src_table_name, o.src_table_name) as src_table_name -- 源表名称
    ,nvl(n.job_cd, o.job_cd) as job_cd -- 任务编码
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间戳
from ${iml_schema}.agt_cap_asset_bal_ctmsf1_tm n
    full join ${iml_schema}.agt_cap_asset_bal_ctmsf1_bk o
        on
            o.asset_bal_id = n.asset_bal_id
            and o.lp_id = n.lp_id
;
commit;

-- 3.1 truncate target table batch_date partition
whenever sqlerror exit sql.sqlcode;
alter table ${iml_schema}.agt_cap_asset_bal truncate partition for ('ctmsf1') reuse storage;

-- 3.2 exchage tm table and target table
alter table ${iml_schema}.agt_cap_asset_bal exchange subpartition p_ctmsf1_${batch_date} with table ${iml_schema}.agt_cap_asset_bal_ctmsf1_ex;

-- 3.3 drop subpartition last_date partition
whenever sqlerror continue none ;
alter table ${iml_schema}.agt_cap_asset_bal drop subpartition p_ctmsf1_${last_date} update global indexes;

-- 4.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iml_schema}.agt_cap_asset_bal to ${iml_schema};

-- 4.2 drop tm table
drop table ${iml_schema}.agt_cap_asset_bal_ctmsf1_tm purge;
drop table ${iml_schema}.agt_cap_asset_bal_ctmsf1_ex purge;
drop table ${iml_schema}.agt_cap_asset_bal_ctmsf1_bk purge;

-- 5 gater table status
exec dbms_stats.gather_table_stats(ownname => '${iml_schema}',tabname => 'agt_cap_asset_bal', partname => 'p_ctmsf1_${batch_date}', ESTIMATE_PERCENT=>10, method_opt=>'for all columns size 1',no_invalidate=>false, force=>true, granularity => 'SUBPARTITION', degree => 8, cascade => true);