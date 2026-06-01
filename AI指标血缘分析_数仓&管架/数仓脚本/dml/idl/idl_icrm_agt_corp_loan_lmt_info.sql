/*
Purpose:    应用集市层-建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd idl_icrm_agt_corp_loan_lmt_info
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
alter table ${idl_schema}.icrm_agt_corp_loan_lmt_info drop partition p_${last_date};
alter table ${idl_schema}.icrm_agt_corp_loan_lmt_info drop partition p_${batch_date};

-- 2.2 add today partition
whenever sqlerror exit sql.sqlcode;
alter table ${idl_schema}.icrm_agt_corp_loan_lmt_info add  partition p_${batch_date} values (to_date('${batch_date}','yyyymmdd'));

-- 2.3 insert data target table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ into ${idl_schema}.icrm_agt_corp_loan_lmt_info partition for (to_date('${batch_date}','yyyymmdd')) (
    etl_dt  -- 数据日期
    ,agt_id  -- 协议编号
    ,lp_id  -- 法人编号
    ,up_level_lmt_flow_num  -- 上层额度流水号
    ,lmt_bus_breed_id  -- 额度业务品种编号
    ,rela_obj_type_cd  -- 关联对象类型代码
    ,rela_obj_id  -- 关联对象编号
    ,cust_id  -- 客户编号
    ,cust_name  -- 客户名称
    ,curr_cd  -- 币种代码
    ,lmt_amt  -- 额度金额
    ,lmt_open  -- 额度敞口
    ,exlus_flg  -- 专属标志
    ,circl_flg  -- 循环标志
    ,margin_ratio  -- 保证金比率
    ,perds  -- 期数
    ,tenor_val  -- 期限值
    ,begin_dt  -- 起始日期
    ,exp_dt  -- 到期日期
    ,rgst_teller_id  -- 登记柜员编号
    ,rgst_org_id  -- 登记机构编号
    ,rgst_dt  -- 登记日期
    ,lmt_update_dt  -- 额度更新日期
    ,invest_way_cd  -- 投资方式代码
    ,onl_lmt  -- 线上额度
    ,ts_appl_amt  -- 暂存申请金额
    ,ts_open_amt  -- 暂存敞口金额
    ,ts_onl_amt  -- 暂存线上金额
    ,group_corp_cust_crdt_lmt  -- 集团公司客户授信额度
    ,group_corp_cust_crdt_open  -- 集团公司客户授信敞口
    ,group_ibank_cust_crdt_lmt  -- 集团同业客户授信额度
    ,group_ibank_cust_crdt_open  -- 集团同业客户授信敞口
    ,ts_group_corp_cust_crdt_lmt  -- 暂存集团公司客户授信额度
    ,ts_group_corp_cust_crdt_open  -- 暂存集团公司客户授信敞口
    ,ts_group_ibank_cust_crdt_lmt  -- 暂存集团同业客户授信额度
    ,ts_group_ibank_cust_crdt_open  -- 暂存集团同业客户授信敞口
    ,job_cd  -- 任务代码
    ,etl_timestamp  -- 数据处理时间
)
select
    to_date('${batch_date}','yyyymmdd') as etl_dt  -- 数据日期
    ,replace(replace(t1.agt_id,chr(13),''),chr(10),'')  -- 协议编号
    ,replace(replace(t1.lp_id,chr(13),''),chr(10),'')  -- 法人编号
    ,replace(replace(t1.up_level_lmt_flow_num,chr(13),''),chr(10),'')  -- 上层额度流水号
    ,replace(replace(t1.lmt_bus_breed_id,chr(13),''),chr(10),'')  -- 额度业务品种编号
    ,replace(replace(t1.rela_obj_type_cd,chr(13),''),chr(10),'')  -- 关联对象类型代码
    ,replace(replace(t1.rela_obj_id,chr(13),''),chr(10),'')  -- 关联对象编号
    ,replace(replace(t1.cust_id,chr(13),''),chr(10),'')  -- 客户编号
    ,replace(replace(t1.cust_name,chr(13),''),chr(10),'')  -- 客户名称
    ,replace(replace(t1.curr_cd,chr(13),''),chr(10),'')  -- 币种代码
    ,t1.lmt_amt  -- 额度金额
    ,t1.lmt_open  -- 额度敞口
    ,replace(replace(t1.exlus_flg,chr(13),''),chr(10),'')  -- 专属标志
    ,replace(replace(t1.circl_flg,chr(13),''),chr(10),'')  -- 循环标志
    ,t1.margin_ratio  -- 保证金比率
    ,t1.perds  -- 期数
    ,t1.tenor_val  -- 期限值
    ,t1.begin_dt  -- 起始日期
    ,t1.exp_dt  -- 到期日期
    ,replace(replace(t1.rgst_teller_id,chr(13),''),chr(10),'')  -- 登记柜员编号
    ,replace(replace(t1.rgst_org_id,chr(13),''),chr(10),'')  -- 登记机构编号
    ,t1.rgst_dt  -- 登记日期
    ,t1.lmt_update_dt  -- 额度更新日期
    ,replace(replace(t1.invest_way_cd,chr(13),''),chr(10),'')  -- 投资方式代码
    ,t1.onl_lmt  -- 线上额度
    ,t1.ts_appl_amt  -- 暂存申请金额
    ,t1.ts_open_amt  -- 暂存敞口金额
    ,t1.ts_onl_amt  -- 暂存线上金额
    ,t1.group_corp_cust_crdt_lmt  -- 集团公司客户授信额度
    ,t1.group_corp_cust_crdt_open  -- 集团公司客户授信敞口
    ,t1.group_ibank_cust_crdt_lmt  -- 集团同业客户授信额度
    ,t1.group_ibank_cust_crdt_open  -- 集团同业客户授信敞口
    ,t1.ts_group_corp_cust_crdt_lmt  -- 暂存集团公司客户授信额度
    ,t1.ts_group_corp_cust_crdt_open  -- 暂存集团公司客户授信敞口
    ,t1.ts_group_ibank_cust_crdt_lmt  -- 暂存集团同业客户授信额度
    ,t1.ts_group_ibank_cust_crdt_open  -- 暂存集团同业客户授信敞口
    ,replace(replace(t1.job_cd,chr(13),''),chr(10),'')  -- 任务代码
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp   --数据处理时间
from ${iml_schema}.agt_corp_loan_lmt_info t1    --公司贷款额度信息表
where t1.create_dt<= to_date('${batch_date}','yyyymmdd') and t1.id_mark <> 'D' ;
commit;


-- 4 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${idl_schema}',tabname => 'icrm_agt_corp_loan_lmt_info',partname => 'p_${batch_date}', granularity => 'PARTITION', degree => 8, cascade => true);