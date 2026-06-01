/*
Purpose:    应用集市层-建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd idl_prd_liab_prod_info
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
--alter table ${idl_schema}.prd_liab_prod_info drop partition p_${last_date};
alter table ${idl_schema}.prd_liab_prod_info drop partition p_${batch_date};

-- 2.2 add today partition
whenever sqlerror exit sql.sqlcode;
alter table ${idl_schema}.prd_liab_prod_info add  partition p_${batch_date} values (to_date('${batch_date}','yyyymmdd'));

-- 2.3 insert data target table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ into ${idl_schema}.prd_liab_prod_info (
    etl_dt  -- 数据日期
    ,lp_id  -- 法人编号
    ,prod_id  -- 产品编号
    ,src_prod_id  -- 源产品编号
    ,prod_descb  -- 产品描述
    ,prod_intnal_id  -- 产品内部编号
    ,prod_effect_dt  -- 产品生效日期
    ,prod_invalid_dt  -- 产品失效日期
    ,prod_cate_cd  -- 产品类别代码
    ,prod_belong_obj_cd  -- 产品所属对象代码
    ,prod_cls_cd_2  -- 产品分类代码2
    ,prod_cls_cd_5  -- 产品分类代码5
    ,dep_kind_cd  -- 存款种类代码
    ,accting_type_cd  -- 会计核算类型代码
    ,prod_modal_tran_flg  -- 产品形态转移标志
    ,check_entry_flg  -- 对账标志
    ,acct_vrfction_flg  -- 账户核查标志
    ,bal_gl_sync_flg  -- 余额总账同步标志
    ,auto_precon_draw_flg  -- 自动预约取款标志
    ,open_acct_lmt_flg  -- 开户限制标志
    ,open_acct_rela_flg  -- 开户关联标志
    ,zero_bal_flg  -- 零余额标志
    ,redt_flg  -- 转存标志
    ,margin_dep_flg  -- 保证金存款标志
    ,cfm_open_acct_exp_day_flg  -- 确认开户到期日标志
    ,od_flg  -- 透支标志
    ,org_ctrl_flg  -- 机构控制标志
    ,emply_prod_flg  -- 员工产品标志
    ,deriv_prod_flg  -- 衍生产品标志
    ,prod_charge_evt_way_cd  -- 产品收费事件方式代码
    ,prod_status_cd  -- 产品状态代码
    ,curr_type_cd  -- 货币类型代码
    ,spec_acct_num_rule_flg  -- 指定账号规则标志
    ,matn_teller_id  -- 维护柜员编号
    ,matn_org_id  -- 维护机构编号
    ,matn_dt  -- 维护日期
    ,matn_tm  -- 维护时间
    ,tm_stamp  -- 时间戳
    ,rec_status_cd  -- 记录状态代码
    ,create_dt  -- 创建日期
    ,update_dt  -- 更新日期
    ,id_mark  -- 删除标识
    ,job_cd -- 任务编码
)
select
    to_date('${batch_date}','yyyymmdd') as etl_dt  -- 数据日期
    ,replace(replace(t1.lp_id,chr(13),''),chr(10),'')  -- 法人编号
    ,replace(replace(t1.prod_id,chr(13),''),chr(10),'')  -- 产品编号
    ,replace(replace(t1.src_prod_id,chr(13),''),chr(10),'')  -- 源产品编号
    ,replace(replace(t1.prod_descb,chr(13),''),chr(10),'')  -- 产品描述
    ,replace(replace(t1.prod_intnal_id,chr(13),''),chr(10),'')  -- 产品内部编号
    ,t1.prod_effect_dt  -- 产品生效日期
    ,t1.prod_invalid_dt  -- 产品失效日期
    ,replace(replace(t1.prod_cate_cd,chr(13),''),chr(10),'')  -- 产品类别代码
    ,replace(replace(t1.prod_belong_obj_cd,chr(13),''),chr(10),'')  -- 产品所属对象代码
    ,replace(replace(t1.prod_cls_cd_2,chr(13),''),chr(10),'')  -- 产品分类代码2
    ,replace(replace(t1.prod_cls_cd_5,chr(13),''),chr(10),'')  -- 产品分类代码5
    ,replace(replace(t1.dep_kind_cd,chr(13),''),chr(10),'')  -- 存款种类代码
    ,replace(replace(t1.accting_type_cd,chr(13),''),chr(10),'')  -- 会计核算类型代码
    ,replace(replace(t1.prod_modal_tran_flg,chr(13),''),chr(10),'')  -- 产品形态转移标志
    ,replace(replace(t1.check_entry_flg,chr(13),''),chr(10),'')  -- 对账标志
    ,replace(replace(t1.acct_vrfction_flg,chr(13),''),chr(10),'')  -- 账户核查标志
    ,replace(replace(t1.bal_gl_sync_flg,chr(13),''),chr(10),'')  -- 余额总账同步标志
    ,replace(replace(t1.auto_precon_draw_flg,chr(13),''),chr(10),'')  -- 自动预约取款标志
    ,replace(replace(t1.open_acct_lmt_flg,chr(13),''),chr(10),'')  -- 开户限制标志
    ,replace(replace(t1.open_acct_rela_flg,chr(13),''),chr(10),'')  -- 开户关联标志
    ,replace(replace(t1.zero_bal_flg,chr(13),''),chr(10),'')  -- 零余额标志
    ,replace(replace(t1.redt_flg,chr(13),''),chr(10),'')  -- 转存标志
    ,replace(replace(t1.margin_dep_flg,chr(13),''),chr(10),'')  -- 保证金存款标志
    ,replace(replace(t1.cfm_open_acct_exp_day_flg,chr(13),''),chr(10),'')  -- 确认开户到期日标志
    ,replace(replace(t1.od_flg,chr(13),''),chr(10),'')  -- 透支标志
    ,replace(replace(t1.org_ctrl_flg,chr(13),''),chr(10),'')  -- 机构控制标志
    ,replace(replace(t1.emply_prod_flg,chr(13),''),chr(10),'')  -- 员工产品标志
    ,replace(replace(t1.deriv_prod_flg,chr(13),''),chr(10),'')  -- 衍生产品标志
    ,replace(replace(t1.prod_charge_evt_way_cd,chr(13),''),chr(10),'')  -- 产品收费事件方式代码
    ,replace(replace(t1.prod_status_cd,chr(13),''),chr(10),'')  -- 产品状态代码
    ,replace(replace(t1.curr_type_cd,chr(13),''),chr(10),'')  -- 货币类型代码
    ,replace(replace(t1.spec_acct_num_rule_flg,chr(13),''),chr(10),'')  -- 指定账号规则标志
    ,replace(replace(t1.matn_teller_id,chr(13),''),chr(10),'')  -- 维护柜员编号
    ,replace(replace(t1.matn_org_id,chr(13),''),chr(10),'')  -- 维护机构编号
    ,t1.matn_dt  -- 维护日期
    ,replace(replace(t1.matn_tm,chr(13),''),chr(10),'')  -- 维护时间
    ,t1.tm_stamp  -- 时间戳
    ,replace(replace(t1.rec_status_cd,chr(13),''),chr(10),'')  -- 记录状态代码
    ,t1.create_dt  -- 创建日期
    ,t1.update_dt  -- 更新日期
    ,replace(replace(t1.id_mark,chr(13),''),chr(10),'')  -- 删除标识
    ,replace(replace(t1.job_cd,chr(13),''),chr(10),'')  -- 任务编码
from ${iml_schema}.prd_liab_prod_info t1    --负债产品信息
;
commit;


-- 4 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${idl_schema}',tabname => 'prd_liab_prod_info',partname => 'p_${batch_date}', granularity => 'PARTITION', degree => 8, cascade => true);