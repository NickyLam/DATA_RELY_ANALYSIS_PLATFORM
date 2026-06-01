/*
Purpose:    应用集市层-建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd idl_pty_indv_cust
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
--alter table ${idl_schema}.pty_indv_cust drop partition p_${last_date};
alter table ${idl_schema}.pty_indv_cust drop partition p_${batch_date};

-- 2.2 add today partition
whenever sqlerror exit sql.sqlcode;
alter table ${idl_schema}.pty_indv_cust add  partition p_${batch_date} values (to_date('${batch_date}','yyyymmdd'));

-- 2.3 insert data target table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ into ${idl_schema}.pty_indv_cust (
    etl_dt  -- 数据日期
    ,cust_id  -- 客户编号
    ,lp_id  -- 法人编号
    ,sorc_sys_cd  -- 源系统代码
    ,gender_cd  -- 性别代码
    ,birth_dt  -- 出生日期
    ,nationty_cd  -- 民族代码
    ,nati_place  -- 籍贯
    ,politic_status_cd  -- 政治面貌代码
    ,marriage_situ_cd  -- 婚姻状况代码
    ,emply_flg  -- 员工标志
    ,age  -- 年龄
    ,resdnt_flg  -- 居民标志
    ,nation_cd  -- 国籍代码
    ,dist_cd  -- 行政区域代码
    ,hxb_shard_flg  -- 我行股东标志
    ,owner_type_cd  -- 业主类型代码
    ,ctysd_rpr_flg  -- 农村户口标志
    ,hxb_rela_party_flg  -- 我行关联方标志
    ,hxb_trast_inter_bus_flg  -- 在我行办理过中间业务标志
    ,hxb_payoff_sal_acct_flg  -- 我行代发工资户标志
    ,hxb_reg_cust_flg  -- 我行定期客户标志
    ,hxb_finc_cust_flg  -- 我行理财客户标志
    ,hxb_vip_cust_idf  -- 我行VIP客户标识
    ,spouse_child_img_flg  -- 配偶及子女移民标志
    ,enjoy_cty_prefr_policy_flg  -- 享受国家优惠政策标志
    ,create_dt  -- 创建日期
    ,update_dt  -- 更新日期
    ,id_mark  -- 删除标识
    ,job_cd -- 任务编码

)
select
    to_date('${batch_date}','yyyymmdd') as etl_dt  -- 数据日期
    ,replace(replace(t1.cust_id,chr(13),''),chr(10),'')  -- 客户编号
    ,replace(replace(t1.lp_id,chr(13),''),chr(10),'')  -- 法人编号
    ,replace(replace(t1.sorc_sys_cd,chr(13),''),chr(10),'')  -- 源系统代码
    ,replace(replace(t1.gender_cd,chr(13),''),chr(10),'')  -- 性别代码
    ,t1.birth_dt  -- 出生日期
    ,replace(replace(t1.nationty_cd,chr(13),''),chr(10),'')  -- 民族代码
    ,replace(replace(t1.nati_place,chr(13),''),chr(10),'')  -- 籍贯
    ,replace(replace(t1.politic_status_cd,chr(13),''),chr(10),'')  -- 政治面貌代码
    ,replace(replace(t1.marriage_situ_cd,chr(13),''),chr(10),'')  -- 婚姻状况代码
    ,replace(replace(t1.emply_flg,chr(13),''),chr(10),'')  -- 员工标志
    ,t1.age  -- 年龄
    ,replace(replace(t1.resdnt_flg,chr(13),''),chr(10),'')  -- 居民标志
    ,replace(replace(t1.nation_cd,chr(13),''),chr(10),'')  -- 国籍代码
    ,replace(replace(t1.dist_cd,chr(13),''),chr(10),'')  -- 行政区域代码
    ,replace(replace(t1.hxb_shard_flg,chr(13),''),chr(10),'')  -- 我行股东标志
    ,replace(replace(t1.owner_type_cd,chr(13),''),chr(10),'')  -- 业主类型代码
    ,replace(replace(t1.ctysd_rpr_flg,chr(13),''),chr(10),'')  -- 农村户口标志
    ,replace(replace(t1.hxb_rela_party_flg,chr(13),''),chr(10),'')  -- 我行关联方标志
    ,replace(replace(t1.hxb_trast_inter_bus_flg,chr(13),''),chr(10),'')  -- 在我行办理过中间业务标志
    ,replace(replace(t1.hxb_payoff_sal_acct_flg,chr(13),''),chr(10),'')  -- 我行代发工资户标志
    ,replace(replace(t1.hxb_reg_cust_flg,chr(13),''),chr(10),'')  -- 我行定期客户标志
    ,replace(replace(t1.hxb_finc_cust_flg,chr(13),''),chr(10),'')  -- 我行理财客户标志
    ,replace(replace(t1.hxb_vip_cust_idf,chr(13),''),chr(10),'')  -- 我行VIP客户标识
    ,replace(replace(t1.spouse_child_img_flg,chr(13),''),chr(10),'')  -- 配偶及子女移民标志
    ,replace(replace(t1.enjoy_cty_prefr_policy_flg,chr(13),''),chr(10),'')  -- 享受国家优惠政策标志
    ,t1.create_dt  -- 创建日期
    ,t1.update_dt  -- 更新日期
    ,replace(replace(t1.id_mark,chr(13),''),chr(10),'')  -- 删除标识
    ,replace(replace(t1.job_cd,chr(13),''),chr(10),'')  -- 任务编码

from ${iml_schema}.pty_indv_cust t1    --个人客户
;
commit;


-- 4 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${idl_schema}',tabname => 'pty_indv_cust',partname => 'p_${batch_date}', granularity => 'PARTITION', degree => 8, cascade => true);