/*
Purpose:    整全模型层-快照表脚本，备份目标表当月数据（不含当天），用前一天数据与当天数据整合后插入到目标表中。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iml_prd_ibank_post_asset_ibmsf1
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
drop table ${iml_schema}.prd_ibank_post_asset_ibmsf1_tm purge;
drop table ${iml_schema}.prd_ibank_post_asset_ibmsf1_ex purge;

-- 2.2 add partition for target table
alter table ${iml_schema}.prd_ibank_post_asset add partition p_ibmsf1 values ('ibmsf1')(
        subpartition p_ibmsf1_${batch_date} values (to_date('${batch_date}','yyyymmdd'))
    )
;
alter table ${iml_schema}.prd_ibank_post_asset modify partition p_ibmsf1
    add subpartition p_ibmsf1_${batch_date} values (to_date('${batch_date}','yyyymmdd'))
;

-- 2.3 if backup table is exists, mean script if failed on last time
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
create table ${iml_schema}.prd_ibank_post_asset_ibmsf1_bk nologging
compress ${option_switch} for query high
as
select * from ${iml_schema}.prd_ibank_post_asset partition for ('ibmsf1')
where create_dt < to_date('${batch_date}','yyyymmdd')
;

-- 2.4 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.prd_ibank_post_asset_ibmsf1_tm
compress ${option_switch} for query high
as
select
    prod_id -- 产品编号
    ,lp_id -- 法人编号
    ,prod_type_cd -- 产品类型代码
    ,prod_cd -- 产品代码
    ,prod_name -- 产品名称
    ,effect_dt -- 生效日期
    ,ftp_int_rat -- ftp利率
    ,remark -- 备注
    ,value_dt -- 起息日期
    ,exp_dt -- 到期日期
    ,rgst_type_cd -- 登记类型代码
    ,proj -- 项目
    ,risk_wt -- 风险权重
    ,risk_asset_tot -- 风险资产总额
    ,rgst_dt -- 登记日期
    ,market_inst -- MARKET_INST
    ,customer_manager -- 客户经理编号
    ,asset_type_cd -- 资产类型代码
    ,market_type_cd -- 市场类型代码
    ,vch_accti_obj_id -- 券核算对象编号
    ,amt -- 金额
    ,effect_flg -- 生效标志
    ,margin_amt -- 保证金金额
    ,dep_rcpt_amt -- 存单金额
    ,cfb_amt -- 财富宝金额
    ,tbond_amt -- 国债金额
    ,pb_amt -- 政策性银行金额
    ,pub_dept_enty_amt -- 公共部门实体金额
    ,other_amt -- 其他金额
    ,acvmnt_belong_emply_id -- 业绩归属员工编号
    ,acvmnt_belong_hq_emply_id -- 业绩归属总行员工编号
    ,etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
from ${iml_schema}.prd_ibank_post_asset
where 0=1;

-- 2.5 create temp table
create table ${iml_schema}.prd_ibank_post_asset_ibmsf1_ex nologging
compress ${option_switch} for query high
as select * from ${iml_schema}.prd_ibank_post_asset partition for ('ibmsf1') where 0=1;

-- 2.1 insert data to tm table
-- ibms_ttrd_position_asset_register-
insert into ${iml_schema}.prd_ibank_post_asset_ibmsf1_tm(
    prod_id -- 产品编号
    ,lp_id -- 法人编号
    ,prod_type_cd -- 产品类型代码
    ,prod_cd -- 产品代码
    ,prod_name -- 产品名称
    ,effect_dt -- 生效日期
    ,ftp_int_rat -- ftp利率
    ,remark -- 备注
    ,value_dt -- 起息日期
    ,exp_dt -- 到期日期
    ,rgst_type_cd -- 登记类型代码
    ,proj -- 项目
    ,risk_wt -- 风险权重
    ,risk_asset_tot -- 风险资产总额
    ,rgst_dt -- 登记日期
    ,market_inst -- MARKET_INST
    ,customer_manager -- 客户经理编号
    ,asset_type_cd -- 资产类型代码
    ,market_type_cd -- 市场类型代码
    ,vch_accti_obj_id -- 券核算对象编号
    ,amt -- 金额
    ,effect_flg -- 生效标志
    ,margin_amt -- 保证金金额
    ,dep_rcpt_amt -- 存单金额
    ,cfb_amt -- 财富宝金额
    ,tbond_amt -- 国债金额
    ,pb_amt -- 政策性银行金额
    ,pub_dept_enty_amt -- 公共部门实体金额
    ,other_amt -- 其他金额
    ,acvmnt_belong_emply_id -- 业绩归属员工编号
    ,acvmnt_belong_hq_emply_id -- 业绩归属总行员工编号
    ,etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
)
select
    '222005'||LPAD(P1.ID,10,'0') -- 产品编号
    ,'9999' -- 法人编号
    ,P1.P_TYPE -- 产品类型代码
    ,P1.I_CODE -- 产品代码
    ,P1.I_NAME -- 产品名称
    ,${iml_schema}.dateformat_max(P1.EFFECTIVE_DATE) -- 生效日期
    ,P1.FTP_RATE -- ftp利率
    ,P1.REMARK -- 备注
    ,${iml_schema}.dateformat_min(P1.START_DATE) -- 起息日期
    ,${iml_schema}.dateformat_max(P1.MTR_DATE) -- 到期日期
    ,P1.REGISTER_TYPE -- 登记类型代码
    ,P1.PROJECT -- 项目
    ,P1.RISK_WEIGHT -- 风险权重
    ,P1.RISK_ASSETS_AMOUNT -- 风险资产总额
    ,${iml_schema}.dateformat_min(P1.REGISTER_DATE) -- 登记日期
    ,P1.MARKET_INST -- MARKET_INST
    ,P1.CUSTOMER_MANAGER -- 客户经理编号
    ,P1.A_TYPE -- 资产类型代码
    ,P1.M_TYPE -- 市场类型代码
    ,P1.OBJ_ID -- 券核算对象编号
    ,P1.AMOUNT -- 金额
    ,NVL(TRIM(P1.USABLE_FLAG),'-') -- 生效标志
    ,P1.ENSURE_AMT -- 保证金金额
    ,P1.DEPOSIT_RECEIPT_AMT -- 存单金额
    ,P1.WEALTH_TREASURE_AMT -- 财富宝金额
    ,P1.GOVERNMENT_BOND_AMT -- 国债金额
    ,P1.POLICY_BANK_AMT -- 政策性银行金额
    ,P1.COMMON_DEPARTMENT_AMT -- 公共部门实体金额
    ,P1.OTHER_AMT -- 其他金额
    ,P1.BELONGER -- 业绩归属员工编号
    ,P1.HEAD_BELONGER -- 业绩归属总行员工编号
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,'ibms_ttrd_position_asset_register' -- 源表名称
    ,'ibmsf1' -- 任务编码
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间戳
from ${iol_schema}.ibms_ttrd_position_asset_register p1
where  1 = 1 
;
commit;


commit;



whenever sqlerror exit sql.sqlcode;
declare
cnt integer;
begin
  for cur in (select 1 from dual) loop
  	select count(1) into cnt from (select 1 from ${iml_schema}.prd_ibank_post_asset_ibmsf1_tm 
  	                                group by 
  	                                        prod_id
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
insert /*+ append */ into ${iml_schema}.prd_ibank_post_asset_ibmsf1_ex(
    prod_id -- 产品编号
    ,lp_id -- 法人编号
    ,prod_type_cd -- 产品类型代码
    ,prod_cd -- 产品代码
    ,prod_name -- 产品名称
    ,effect_dt -- 生效日期
    ,ftp_int_rat -- ftp利率
    ,remark -- 备注
    ,value_dt -- 起息日期
    ,exp_dt -- 到期日期
    ,rgst_type_cd -- 登记类型代码
    ,proj -- 项目
    ,risk_wt -- 风险权重
    ,risk_asset_tot -- 风险资产总额
    ,rgst_dt -- 登记日期
    ,market_inst -- MARKET_INST
    ,customer_manager -- 客户经理编号
    ,asset_type_cd -- 资产类型代码
    ,market_type_cd -- 市场类型代码
    ,vch_accti_obj_id -- 券核算对象编号
    ,amt -- 金额
    ,effect_flg -- 生效标志
    ,margin_amt -- 保证金金额
    ,dep_rcpt_amt -- 存单金额
    ,cfb_amt -- 财富宝金额
    ,tbond_amt -- 国债金额
    ,pb_amt -- 政策性银行金额
    ,pub_dept_enty_amt -- 公共部门实体金额
    ,other_amt -- 其他金额
    ,acvmnt_belong_emply_id -- 业绩归属员工编号
    ,acvmnt_belong_hq_emply_id -- 业绩归属总行员工编号
    ,create_dt -- 创建日期
    ,update_dt -- 更新日期
    ,etl_dt -- ETL处理日期
    ,id_mark -- 增删标志
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
)
select
    nvl(n.prod_id, o.prod_id) as prod_id -- 产品编号
    ,nvl(n.lp_id, o.lp_id) as lp_id -- 法人编号
    ,nvl(n.prod_type_cd, o.prod_type_cd) as prod_type_cd -- 产品类型代码
    ,nvl(n.prod_cd, o.prod_cd) as prod_cd -- 产品代码
    ,nvl(n.prod_name, o.prod_name) as prod_name -- 产品名称
    ,nvl(n.effect_dt, o.effect_dt) as effect_dt -- 生效日期
    ,nvl(n.ftp_int_rat, o.ftp_int_rat) as ftp_int_rat -- ftp利率
    ,nvl(n.remark, o.remark) as remark -- 备注
    ,nvl(n.value_dt, o.value_dt) as value_dt -- 起息日期
    ,nvl(n.exp_dt, o.exp_dt) as exp_dt -- 到期日期
    ,nvl(n.rgst_type_cd, o.rgst_type_cd) as rgst_type_cd -- 登记类型代码
    ,nvl(n.proj, o.proj) as proj -- 项目
    ,nvl(n.risk_wt, o.risk_wt) as risk_wt -- 风险权重
    ,nvl(n.risk_asset_tot, o.risk_asset_tot) as risk_asset_tot -- 风险资产总额
    ,nvl(n.rgst_dt, o.rgst_dt) as rgst_dt -- 登记日期
    ,nvl(n.market_inst, o.market_inst) as market_inst -- MARKET_INST
    ,nvl(n.customer_manager, o.customer_manager) as customer_manager -- 客户经理编号
    ,nvl(n.asset_type_cd, o.asset_type_cd) as asset_type_cd -- 资产类型代码
    ,nvl(n.market_type_cd, o.market_type_cd) as market_type_cd -- 市场类型代码
    ,nvl(n.vch_accti_obj_id, o.vch_accti_obj_id) as vch_accti_obj_id -- 券核算对象编号
    ,nvl(n.amt, o.amt) as amt -- 金额
    ,nvl(n.effect_flg, o.effect_flg) as effect_flg -- 生效标志
    ,nvl(n.margin_amt, o.margin_amt) as margin_amt -- 保证金金额
    ,nvl(n.dep_rcpt_amt, o.dep_rcpt_amt) as dep_rcpt_amt -- 存单金额
    ,nvl(n.cfb_amt, o.cfb_amt) as cfb_amt -- 财富宝金额
    ,nvl(n.tbond_amt, o.tbond_amt) as tbond_amt -- 国债金额
    ,nvl(n.pb_amt, o.pb_amt) as pb_amt -- 政策性银行金额
    ,nvl(n.pub_dept_enty_amt, o.pub_dept_enty_amt) as pub_dept_enty_amt -- 公共部门实体金额
    ,nvl(n.other_amt, o.other_amt) as other_amt -- 其他金额
    ,nvl(n.acvmnt_belong_emply_id, o.acvmnt_belong_emply_id) as acvmnt_belong_emply_id -- 业绩归属员工编号
    ,nvl(n.acvmnt_belong_hq_emply_id, o.acvmnt_belong_hq_emply_id) as acvmnt_belong_hq_emply_id -- 业绩归属总行员工编号
    ,nvl(o.create_dt, to_date('${batch_date}', 'yyyymmdd')) as create_dt -- 创建日期
    ,case when (
                o.prod_id is null
                and o.lp_id is null
            ) or (
                o.prod_type_cd <> n.prod_type_cd
                or o.prod_cd <> n.prod_cd
                or o.prod_name <> n.prod_name
                or o.effect_dt <> n.effect_dt
                or o.ftp_int_rat <> n.ftp_int_rat
                or o.remark <> n.remark
                or o.value_dt <> n.value_dt
                or o.exp_dt <> n.exp_dt
                or o.rgst_type_cd <> n.rgst_type_cd
                or o.proj <> n.proj
                or o.risk_wt <> n.risk_wt
                or o.risk_asset_tot <> n.risk_asset_tot
                or o.rgst_dt <> n.rgst_dt
                or o.market_inst <> n.market_inst
                or o.customer_manager <> n.customer_manager
                or o.asset_type_cd <> n.asset_type_cd
                or o.market_type_cd <> n.market_type_cd
                or o.vch_accti_obj_id <> n.vch_accti_obj_id
                or o.amt <> n.amt
                or o.effect_flg <> n.effect_flg
                or o.margin_amt <> n.margin_amt
                or o.dep_rcpt_amt <> n.dep_rcpt_amt
                or o.cfb_amt <> n.cfb_amt
                or o.tbond_amt <> n.tbond_amt
                or o.pb_amt <> n.pb_amt
                or o.pub_dept_enty_amt <> n.pub_dept_enty_amt
                or o.other_amt <> n.other_amt
                or o.acvmnt_belong_emply_id <> n.acvmnt_belong_emply_id
                or o.acvmnt_belong_hq_emply_id <> n.acvmnt_belong_hq_emply_id
            ) or (
                 case when (
                           n.prod_id is null
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
                n.prod_id is null
                and n.lp_id is null
            )
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,nvl(n.src_table_name, o.src_table_name) as src_table_name -- 源表名称
    ,nvl(n.job_cd, o.job_cd) as job_cd -- 任务编码
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间戳
from ${iml_schema}.prd_ibank_post_asset_ibmsf1_tm n
    full join ${iml_schema}.prd_ibank_post_asset_ibmsf1_bk o
        on
            o.prod_id = n.prod_id
            and o.lp_id = n.lp_id
;
commit;

-- 3.1 truncate target table batch_date partition
whenever sqlerror exit sql.sqlcode;
alter table ${iml_schema}.prd_ibank_post_asset truncate partition for ('ibmsf1') reuse storage;

-- 3.2 exchage tm table and target table
alter table ${iml_schema}.prd_ibank_post_asset exchange subpartition p_ibmsf1_${batch_date} with table ${iml_schema}.prd_ibank_post_asset_ibmsf1_ex;

-- 3.3 drop subpartition last_date partition
whenever sqlerror continue none ;
alter table ${iml_schema}.prd_ibank_post_asset drop subpartition p_ibmsf1_${last_date} update global indexes;

-- 4.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iml_schema}.prd_ibank_post_asset to ${iml_schema};

-- 4.2 drop tm table
drop table ${iml_schema}.prd_ibank_post_asset_ibmsf1_tm purge;
drop table ${iml_schema}.prd_ibank_post_asset_ibmsf1_ex purge;
drop table ${iml_schema}.prd_ibank_post_asset_ibmsf1_bk purge;

-- 5 gater table status
exec dbms_stats.gather_table_stats(ownname => '${iml_schema}',tabname => 'prd_ibank_post_asset', partname => 'p_ibmsf1_${batch_date}', ESTIMATE_PERCENT=>10, method_opt=>'for all columns size 1',no_invalidate=>false, force=>true, granularity => 'SUBPARTITION', degree => 8, cascade => true);