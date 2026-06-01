/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_eifs_t01_corp_group_info
CreateDate: 20180515
Logs:
    zjj 2018-05-15 新建脚本
*/

set timing on

-- 1 alter parallel
alter session force parallel query parallel 8;
alter session force parallel dml parallel 8;
-- alter session force parallel ddl parallel 8;

-- 2.1 create backup table
-- if backup table is exists, mean script if failed on last time
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
create table ${iol_schema}.eifs_t01_corp_group_info_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.eifs_t01_corp_group_info
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd');

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.eifs_t01_corp_group_info_op purge;
drop table ${iol_schema}.eifs_t01_corp_group_info_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.eifs_t01_corp_group_info_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.eifs_t01_corp_group_info where 0=1;

create table ${iol_schema}.eifs_t01_corp_group_info_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.eifs_t01_corp_group_info where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.eifs_t01_corp_group_info_cl(
            group_id -- 群体id
            ,group_num -- 集团编号
            ,group_name -- 集团名称
            ,group_short_name -- 集团简称
            ,group_en_name -- 集团英文名称
            ,phys_addr_cty_zone_cd -- 国家和地区
            ,group_work_addr_dist_cd -- 集团办公地行政区划
            ,group_dom_work_addr -- 集团国内办公地址
            ,trade_group_ind -- 同业集团标志
            ,group_mem_cnt -- 集团成员数
            ,group_risk_warn_info_cd -- 集团风险预警信号
            ,group_status -- 集团状态
            ,tax_pay_ctzn_idnt -- 税收居民身份
            ,prnt_cust_no -- 母公司客户号
            ,tax_org_type -- 税收机构类别
            ,cust_mgr_name -- 客户经理姓名
            ,cust_mgr_num -- 客户经理编号
            ,create_te -- 创建柜员
            ,create_org -- 创建机构号
            ,init_system_id -- 创建渠道
            ,init_created_ts -- 源系统创建时间
            ,created_ts -- 进入ecif的时间
            ,updated_ts -- 在ecif中失效的时间
            ,last_updated_te -- 最新更新柜员
            ,last_updated_org -- 最新更新机构号
            ,last_system_id -- 最新更新渠道
            ,last_updated_ts -- 最新更新时间
            ,grp_typ -- 
            ,wthr_ghb_assoc_txn -- 
            ,fst_busi -- 
            ,pri_major_main_biz_bus_pct -- 
            ,scd_busi -- 
            ,scd_major_main_biz_bus_pct -- 
            ,third_busi -- 
            ,third_major_main_biz_bus_pct -- 
            ,actl_ctrl_cnt -- 
            ,main_cntri_cnt -- 
            ,upd_offic_loc_date -- 
            ,src_sys_num -- 来源系统编号
            ,last_updated_src_sys_num -- 最新更新源系统编号
            ,actl_ctrl_cert_num -- 实际控制人证件代码
            ,actl_ctrl_iden_typ -- 实际控制人证件类型
            ,actl_ctrl_name -- 实际控制人名称
            ,actl_ctrl_nation_cd -- 实际控制人国别
            ,base_group_cust_no -- 总分行认定集团客户
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.eifs_t01_corp_group_info_op(
            group_id -- 群体id
            ,group_num -- 集团编号
            ,group_name -- 集团名称
            ,group_short_name -- 集团简称
            ,group_en_name -- 集团英文名称
            ,phys_addr_cty_zone_cd -- 国家和地区
            ,group_work_addr_dist_cd -- 集团办公地行政区划
            ,group_dom_work_addr -- 集团国内办公地址
            ,trade_group_ind -- 同业集团标志
            ,group_mem_cnt -- 集团成员数
            ,group_risk_warn_info_cd -- 集团风险预警信号
            ,group_status -- 集团状态
            ,tax_pay_ctzn_idnt -- 税收居民身份
            ,prnt_cust_no -- 母公司客户号
            ,tax_org_type -- 税收机构类别
            ,cust_mgr_name -- 客户经理姓名
            ,cust_mgr_num -- 客户经理编号
            ,create_te -- 创建柜员
            ,create_org -- 创建机构号
            ,init_system_id -- 创建渠道
            ,init_created_ts -- 源系统创建时间
            ,created_ts -- 进入ecif的时间
            ,updated_ts -- 在ecif中失效的时间
            ,last_updated_te -- 最新更新柜员
            ,last_updated_org -- 最新更新机构号
            ,last_system_id -- 最新更新渠道
            ,last_updated_ts -- 最新更新时间
            ,grp_typ -- 
            ,wthr_ghb_assoc_txn -- 
            ,fst_busi -- 
            ,pri_major_main_biz_bus_pct -- 
            ,scd_busi -- 
            ,scd_major_main_biz_bus_pct -- 
            ,third_busi -- 
            ,third_major_main_biz_bus_pct -- 
            ,actl_ctrl_cnt -- 
            ,main_cntri_cnt -- 
            ,upd_offic_loc_date -- 
            ,src_sys_num -- 来源系统编号
            ,last_updated_src_sys_num -- 最新更新源系统编号
            ,actl_ctrl_cert_num -- 实际控制人证件代码
            ,actl_ctrl_iden_typ -- 实际控制人证件类型
            ,actl_ctrl_name -- 实际控制人名称
            ,actl_ctrl_nation_cd -- 实际控制人国别
            ,base_group_cust_no -- 总分行认定集团客户
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.group_id, o.group_id) as group_id -- 群体id
    ,nvl(n.group_num, o.group_num) as group_num -- 集团编号
    ,nvl(n.group_name, o.group_name) as group_name -- 集团名称
    ,nvl(n.group_short_name, o.group_short_name) as group_short_name -- 集团简称
    ,nvl(n.group_en_name, o.group_en_name) as group_en_name -- 集团英文名称
    ,nvl(n.phys_addr_cty_zone_cd, o.phys_addr_cty_zone_cd) as phys_addr_cty_zone_cd -- 国家和地区
    ,nvl(n.group_work_addr_dist_cd, o.group_work_addr_dist_cd) as group_work_addr_dist_cd -- 集团办公地行政区划
    ,nvl(n.group_dom_work_addr, o.group_dom_work_addr) as group_dom_work_addr -- 集团国内办公地址
    ,nvl(n.trade_group_ind, o.trade_group_ind) as trade_group_ind -- 同业集团标志
    ,nvl(n.group_mem_cnt, o.group_mem_cnt) as group_mem_cnt -- 集团成员数
    ,nvl(n.group_risk_warn_info_cd, o.group_risk_warn_info_cd) as group_risk_warn_info_cd -- 集团风险预警信号
    ,nvl(n.group_status, o.group_status) as group_status -- 集团状态
    ,nvl(n.tax_pay_ctzn_idnt, o.tax_pay_ctzn_idnt) as tax_pay_ctzn_idnt -- 税收居民身份
    ,nvl(n.prnt_cust_no, o.prnt_cust_no) as prnt_cust_no -- 母公司客户号
    ,nvl(n.tax_org_type, o.tax_org_type) as tax_org_type -- 税收机构类别
    ,nvl(n.cust_mgr_name, o.cust_mgr_name) as cust_mgr_name -- 客户经理姓名
    ,nvl(n.cust_mgr_num, o.cust_mgr_num) as cust_mgr_num -- 客户经理编号
    ,nvl(n.create_te, o.create_te) as create_te -- 创建柜员
    ,nvl(n.create_org, o.create_org) as create_org -- 创建机构号
    ,nvl(n.init_system_id, o.init_system_id) as init_system_id -- 创建渠道
    ,nvl(n.init_created_ts, o.init_created_ts) as init_created_ts -- 源系统创建时间
    ,nvl(n.created_ts, o.created_ts) as created_ts -- 进入ecif的时间
    ,nvl(n.updated_ts, o.updated_ts) as updated_ts -- 在ecif中失效的时间
    ,nvl(n.last_updated_te, o.last_updated_te) as last_updated_te -- 最新更新柜员
    ,nvl(n.last_updated_org, o.last_updated_org) as last_updated_org -- 最新更新机构号
    ,nvl(n.last_system_id, o.last_system_id) as last_system_id -- 最新更新渠道
    ,nvl(n.last_updated_ts, o.last_updated_ts) as last_updated_ts -- 最新更新时间
    ,nvl(n.grp_typ, o.grp_typ) as grp_typ -- 
    ,nvl(n.wthr_ghb_assoc_txn, o.wthr_ghb_assoc_txn) as wthr_ghb_assoc_txn -- 
    ,nvl(n.fst_busi, o.fst_busi) as fst_busi -- 
    ,nvl(n.pri_major_main_biz_bus_pct, o.pri_major_main_biz_bus_pct) as pri_major_main_biz_bus_pct -- 
    ,nvl(n.scd_busi, o.scd_busi) as scd_busi -- 
    ,nvl(n.scd_major_main_biz_bus_pct, o.scd_major_main_biz_bus_pct) as scd_major_main_biz_bus_pct -- 
    ,nvl(n.third_busi, o.third_busi) as third_busi -- 
    ,nvl(n.third_major_main_biz_bus_pct, o.third_major_main_biz_bus_pct) as third_major_main_biz_bus_pct -- 
    ,nvl(n.actl_ctrl_cnt, o.actl_ctrl_cnt) as actl_ctrl_cnt -- 
    ,nvl(n.main_cntri_cnt, o.main_cntri_cnt) as main_cntri_cnt -- 
    ,nvl(n.upd_offic_loc_date, o.upd_offic_loc_date) as upd_offic_loc_date -- 
    ,nvl(n.src_sys_num, o.src_sys_num) as src_sys_num -- 来源系统编号
    ,nvl(n.last_updated_src_sys_num, o.last_updated_src_sys_num) as last_updated_src_sys_num -- 最新更新源系统编号
    ,nvl(n.actl_ctrl_cert_num, o.actl_ctrl_cert_num) as actl_ctrl_cert_num -- 实际控制人证件代码
    ,nvl(n.actl_ctrl_iden_typ, o.actl_ctrl_iden_typ) as actl_ctrl_iden_typ -- 实际控制人证件类型
    ,nvl(n.actl_ctrl_name, o.actl_ctrl_name) as actl_ctrl_name -- 实际控制人名称
    ,nvl(n.actl_ctrl_nation_cd, o.actl_ctrl_nation_cd) as actl_ctrl_nation_cd -- 实际控制人国别
    ,nvl(n.base_group_cust_no, o.base_group_cust_no) as base_group_cust_no -- 总分行认定集团客户
    ,case when
            n.group_id is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.group_id is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.group_id is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from (select * from ${iol_schema}.eifs_t01_corp_group_info_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.eifs_t01_corp_group_info where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.group_id = n.group_id
where (
        o.group_id is null
    )
    or (
        n.group_id is null
    )
    or (
        o.group_num <> n.group_num
        or o.group_name <> n.group_name
        or o.group_short_name <> n.group_short_name
        or o.group_en_name <> n.group_en_name
        or o.phys_addr_cty_zone_cd <> n.phys_addr_cty_zone_cd
        or o.group_work_addr_dist_cd <> n.group_work_addr_dist_cd
        or o.group_dom_work_addr <> n.group_dom_work_addr
        or o.trade_group_ind <> n.trade_group_ind
        or o.group_mem_cnt <> n.group_mem_cnt
        or o.group_risk_warn_info_cd <> n.group_risk_warn_info_cd
        or o.group_status <> n.group_status
        or o.tax_pay_ctzn_idnt <> n.tax_pay_ctzn_idnt
        or o.prnt_cust_no <> n.prnt_cust_no
        or o.tax_org_type <> n.tax_org_type
        or o.cust_mgr_name <> n.cust_mgr_name
        or o.cust_mgr_num <> n.cust_mgr_num
        or o.create_te <> n.create_te
        or o.create_org <> n.create_org
        or o.init_system_id <> n.init_system_id
        or o.init_created_ts <> n.init_created_ts
        or o.created_ts <> n.created_ts
        or o.updated_ts <> n.updated_ts
        or o.last_updated_te <> n.last_updated_te
        or o.last_updated_org <> n.last_updated_org
        or o.last_system_id <> n.last_system_id
        or o.last_updated_ts <> n.last_updated_ts
        or o.grp_typ <> n.grp_typ
        or o.wthr_ghb_assoc_txn <> n.wthr_ghb_assoc_txn
        or o.fst_busi <> n.fst_busi
        or o.pri_major_main_biz_bus_pct <> n.pri_major_main_biz_bus_pct
        or o.scd_busi <> n.scd_busi
        or o.scd_major_main_biz_bus_pct <> n.scd_major_main_biz_bus_pct
        or o.third_busi <> n.third_busi
        or o.third_major_main_biz_bus_pct <> n.third_major_main_biz_bus_pct
        or o.actl_ctrl_cnt <> n.actl_ctrl_cnt
        or o.main_cntri_cnt <> n.main_cntri_cnt
        or o.upd_offic_loc_date <> n.upd_offic_loc_date
        or o.src_sys_num <> n.src_sys_num
        or o.last_updated_src_sys_num <> n.last_updated_src_sys_num
        or o.actl_ctrl_cert_num <> n.actl_ctrl_cert_num
        or o.actl_ctrl_iden_typ <> n.actl_ctrl_iden_typ
        or o.actl_ctrl_name <> n.actl_ctrl_name
        or o.actl_ctrl_nation_cd <> n.actl_ctrl_nation_cd
        or o.base_group_cust_no <> n.base_group_cust_no
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.eifs_t01_corp_group_info_cl(
            group_id -- 群体id
            ,group_num -- 集团编号
            ,group_name -- 集团名称
            ,group_short_name -- 集团简称
            ,group_en_name -- 集团英文名称
            ,phys_addr_cty_zone_cd -- 国家和地区
            ,group_work_addr_dist_cd -- 集团办公地行政区划
            ,group_dom_work_addr -- 集团国内办公地址
            ,trade_group_ind -- 同业集团标志
            ,group_mem_cnt -- 集团成员数
            ,group_risk_warn_info_cd -- 集团风险预警信号
            ,group_status -- 集团状态
            ,tax_pay_ctzn_idnt -- 税收居民身份
            ,prnt_cust_no -- 母公司客户号
            ,tax_org_type -- 税收机构类别
            ,cust_mgr_name -- 客户经理姓名
            ,cust_mgr_num -- 客户经理编号
            ,create_te -- 创建柜员
            ,create_org -- 创建机构号
            ,init_system_id -- 创建渠道
            ,init_created_ts -- 源系统创建时间
            ,created_ts -- 进入ecif的时间
            ,updated_ts -- 在ecif中失效的时间
            ,last_updated_te -- 最新更新柜员
            ,last_updated_org -- 最新更新机构号
            ,last_system_id -- 最新更新渠道
            ,last_updated_ts -- 最新更新时间
            ,grp_typ -- 
            ,wthr_ghb_assoc_txn -- 
            ,fst_busi -- 
            ,pri_major_main_biz_bus_pct -- 
            ,scd_busi -- 
            ,scd_major_main_biz_bus_pct -- 
            ,third_busi -- 
            ,third_major_main_biz_bus_pct -- 
            ,actl_ctrl_cnt -- 
            ,main_cntri_cnt -- 
            ,upd_offic_loc_date -- 
            ,src_sys_num -- 来源系统编号
            ,last_updated_src_sys_num -- 最新更新源系统编号
            ,actl_ctrl_cert_num -- 实际控制人证件代码
            ,actl_ctrl_iden_typ -- 实际控制人证件类型
            ,actl_ctrl_name -- 实际控制人名称
            ,actl_ctrl_nation_cd -- 实际控制人国别
            ,base_group_cust_no -- 总分行认定集团客户
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.eifs_t01_corp_group_info_op(
            group_id -- 群体id
            ,group_num -- 集团编号
            ,group_name -- 集团名称
            ,group_short_name -- 集团简称
            ,group_en_name -- 集团英文名称
            ,phys_addr_cty_zone_cd -- 国家和地区
            ,group_work_addr_dist_cd -- 集团办公地行政区划
            ,group_dom_work_addr -- 集团国内办公地址
            ,trade_group_ind -- 同业集团标志
            ,group_mem_cnt -- 集团成员数
            ,group_risk_warn_info_cd -- 集团风险预警信号
            ,group_status -- 集团状态
            ,tax_pay_ctzn_idnt -- 税收居民身份
            ,prnt_cust_no -- 母公司客户号
            ,tax_org_type -- 税收机构类别
            ,cust_mgr_name -- 客户经理姓名
            ,cust_mgr_num -- 客户经理编号
            ,create_te -- 创建柜员
            ,create_org -- 创建机构号
            ,init_system_id -- 创建渠道
            ,init_created_ts -- 源系统创建时间
            ,created_ts -- 进入ecif的时间
            ,updated_ts -- 在ecif中失效的时间
            ,last_updated_te -- 最新更新柜员
            ,last_updated_org -- 最新更新机构号
            ,last_system_id -- 最新更新渠道
            ,last_updated_ts -- 最新更新时间
            ,grp_typ -- 
            ,wthr_ghb_assoc_txn -- 
            ,fst_busi -- 
            ,pri_major_main_biz_bus_pct -- 
            ,scd_busi -- 
            ,scd_major_main_biz_bus_pct -- 
            ,third_busi -- 
            ,third_major_main_biz_bus_pct -- 
            ,actl_ctrl_cnt -- 
            ,main_cntri_cnt -- 
            ,upd_offic_loc_date -- 
            ,src_sys_num -- 来源系统编号
            ,last_updated_src_sys_num -- 最新更新源系统编号
            ,actl_ctrl_cert_num -- 实际控制人证件代码
            ,actl_ctrl_iden_typ -- 实际控制人证件类型
            ,actl_ctrl_name -- 实际控制人名称
            ,actl_ctrl_nation_cd -- 实际控制人国别
            ,base_group_cust_no -- 总分行认定集团客户
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.group_id -- 群体id
    ,o.group_num -- 集团编号
    ,o.group_name -- 集团名称
    ,o.group_short_name -- 集团简称
    ,o.group_en_name -- 集团英文名称
    ,o.phys_addr_cty_zone_cd -- 国家和地区
    ,o.group_work_addr_dist_cd -- 集团办公地行政区划
    ,o.group_dom_work_addr -- 集团国内办公地址
    ,o.trade_group_ind -- 同业集团标志
    ,o.group_mem_cnt -- 集团成员数
    ,o.group_risk_warn_info_cd -- 集团风险预警信号
    ,o.group_status -- 集团状态
    ,o.tax_pay_ctzn_idnt -- 税收居民身份
    ,o.prnt_cust_no -- 母公司客户号
    ,o.tax_org_type -- 税收机构类别
    ,o.cust_mgr_name -- 客户经理姓名
    ,o.cust_mgr_num -- 客户经理编号
    ,o.create_te -- 创建柜员
    ,o.create_org -- 创建机构号
    ,o.init_system_id -- 创建渠道
    ,o.init_created_ts -- 源系统创建时间
    ,o.created_ts -- 进入ecif的时间
    ,o.updated_ts -- 在ecif中失效的时间
    ,o.last_updated_te -- 最新更新柜员
    ,o.last_updated_org -- 最新更新机构号
    ,o.last_system_id -- 最新更新渠道
    ,o.last_updated_ts -- 最新更新时间
    ,o.grp_typ -- 
    ,o.wthr_ghb_assoc_txn -- 
    ,o.fst_busi -- 
    ,o.pri_major_main_biz_bus_pct -- 
    ,o.scd_busi -- 
    ,o.scd_major_main_biz_bus_pct -- 
    ,o.third_busi -- 
    ,o.third_major_main_biz_bus_pct -- 
    ,o.actl_ctrl_cnt -- 
    ,o.main_cntri_cnt -- 
    ,o.upd_offic_loc_date -- 
    ,o.src_sys_num -- 来源系统编号
    ,o.last_updated_src_sys_num -- 最新更新源系统编号
    ,o.actl_ctrl_cert_num -- 实际控制人证件代码
    ,o.actl_ctrl_iden_typ -- 实际控制人证件类型
    ,o.actl_ctrl_name -- 实际控制人名称
    ,o.actl_ctrl_nation_cd -- 实际控制人国别
    ,o.base_group_cust_no -- 总分行认定集团客户
    ,o.start_dt -- 开始时间
    ,case when n.start_dt is not null then to_date('${batch_date}', 'yyyymmdd')
          when o.end_dt >= to_date('${batch_date}','yyyymmdd') then to_date('20991231','yyyymmdd')
          else o.end_dt
     end as end_dt -- 结束时间
    ,case when n.start_dt is not null
          then 'I'
          when o.end_dt >= to_date('${batch_date}','yyyymmdd')
          then 'I'
          else o.id_mark
     end as id_mark  -- 增删标志 
    ,o.etl_timestamp -- ETL处理时间
from ${iol_schema}.eifs_t01_corp_group_info_bk o
    left join ${iol_schema}.eifs_t01_corp_group_info_op n
        on
            o.group_id = n.group_id
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.eifs_t01_corp_group_info_cl d
        on
            o.group_id = d.group_id
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;

-- 4.1 truncate target table
--truncate table ${iol_schema}.eifs_t01_corp_group_info;

-- 4.2 rebuild partition
declare
v_sql varchar2(100);
begin
for cur in (select partition_name from all_tab_partitions where table_owner=upper('${iol_schema}') and table_name=upper('eifs_t01_corp_group_info') and substr(partition_name,3) >= '${batch_date}' and substr(partition_name,3) < '20991231') loop
    v_sql := 'alter table ${iol_schema}.eifs_t01_corp_group_info drop partition ' || cur.partition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/
alter table ${iol_schema}.eifs_t01_corp_group_info add partition p_${batch_date} values(to_date('${batch_date}','YYYYMMDD'));

-- 4.3 exchange partition
alter table ${iol_schema}.eifs_t01_corp_group_info exchange partition p_${batch_date} with table ${iol_schema}.eifs_t01_corp_group_info_cl;
alter table ${iol_schema}.eifs_t01_corp_group_info exchange partition p_20991231 with table ${iol_schema}.eifs_t01_corp_group_info_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.eifs_t01_corp_group_info to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.eifs_t01_corp_group_info_op purge;
drop table ${iol_schema}.eifs_t01_corp_group_info_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.eifs_t01_corp_group_info_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'eifs_t01_corp_group_info',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
