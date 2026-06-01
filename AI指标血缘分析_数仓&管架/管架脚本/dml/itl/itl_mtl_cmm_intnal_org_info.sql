/*
Purpose:    技术缓冲层脚本，把数据文件加载到目标表的当天分区中。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd itl_mtl_cmm_intnal_org_info
CreateDate: 20180515
Logs:
    luzd 2019-05-27 新建脚本
*/

set timing on

-- 1 alter parallel
alter session force parallel query parallel 8;
alter session force parallel dml parallel 8;
-- alter session force parallel ddl parallel 8;


-- 2.1 drop timeout partition and add partition
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none;
-- alter table ${itl_schema}.mtl_cmm_intnal_org_info drop partition p_${retain_day};  20200901去除删除策略，保留全部
alter table ${itl_schema}.mtl_cmm_intnal_org_info drop partition p_${batch_date};

-- 2.2 add today partition
whenever sqlerror exit sql.sqlcode;
alter table ${itl_schema}.mtl_cmm_intnal_org_info add  partition p_${batch_date} values (to_date('${batch_date}','yyyymmdd'));

-- 2.3 insert data target table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ into ${itl_schema}.mtl_cmm_intnal_org_info partition for (to_date('${batch_date}','yyyymmdd')) (
     lp_id -- 法人编号
    ,org_id -- 机构编号
    ,org_name -- 机构名称
    ,org_abbr -- 机构简称
    ,princ_emply_id -- 负责人员工编号
    ,cbrc_fin_inst_id -- 银监会金融机构编号
    ,unionpay_fin_inst_id -- 银联金融机构编号
    ,fin_inst_idf_code -- 金融机构标识码
    ,bus_lics_num -- 营业执照号码
    ,fin_lics_num -- 金融许可证号
    ,pbc_pay_bank_no -- 人行支付行号
    ,fin_inst_code -- 金融机构编码
    ,hq_org_id -- 总行机构编号
    ,hq_org_name -- 总行机构名称
    ,brch_id -- 分行编号
    ,brch_name -- 分行名称
    ,subrch_id -- 支行编号
    ,subrch_name -- 支行名称
    ,org_type_cd -- 机构类型代码
    ,org_lev_cd -- 机构级别代码
    ,org_status_cd -- 机构状态代码
    ,bus_status_cd -- 营业状态代码
    ,bus_org_flg -- 营业机构标志
    ,enty_org_flg -- 实体机构标志
    ,accti_org_flg -- 核算机构标志
    ,admin_org_flg -- 行政机构标志
    ,acct_instit_flg -- 账务机构标志
    ,vtual_accti_org_flg -- 虚拟核算机构标志
    ,admin_super_org_id -- 行政上级机构编号
    ,acct_super_org_id -- 账务上级机构编号
    ,accti_super_org_id -- 核算上级机构编号
    ,func_org_id -- 职能机构编号
    ,func_dept_id -- 职能部门编号
    ,cty_rg_cd -- 国家和地区代码
    ,prov_cd -- 省代码
    ,city_cd -- 市代码
    ,county_cd -- 县代码
    ,phys_addr -- 物理地址
    ,ddd_area_cd -- 国内长途区号
    ,phone -- 联系电话
    ,zip_cd -- 邮政编码
    ,org_found_dt -- 机构成立日期
    ,org_revo_dt -- 机构撤销日期
    ,org_start_bus_tm -- 机构开始营业时间
    ,org_end_bus_tm -- 机构结束营业时间
    ,etl_dt -- ETL处理日期
    ,etl_timestamp -- ETL处理时间
)
select
     nvl(trim(lp_id), ' ') as lp_id -- 法人编号
    ,nvl(trim(org_id), ' ') as org_id -- 机构编号
    ,nvl(trim(org_name), ' ') as org_name -- 机构名称
    ,nvl(trim(org_abbr), ' ') as org_abbr -- 机构简称
    ,nvl(trim(princ_emply_id), ' ') as princ_emply_id -- 负责人员工编号
    ,nvl(trim(cbrc_fin_inst_id), ' ') as cbrc_fin_inst_id -- 银监会金融机构编号
    ,nvl(trim(unionpay_fin_inst_id), ' ') as unionpay_fin_inst_id -- 银联金融机构编号
    ,nvl(trim(fin_inst_idf_code), ' ') as fin_inst_idf_code -- 金融机构标识码
    ,nvl(trim(bus_lics_num), ' ') as bus_lics_num -- 营业执照号码
    ,nvl(trim(fin_lics_num), ' ') as fin_lics_num -- 金融许可证号
    ,nvl(trim(pbc_pay_bank_no), ' ') as pbc_pay_bank_no -- 人行支付行号
    ,nvl(trim(fin_inst_code), ' ') as fin_inst_code -- 金融机构编码
    ,nvl(trim(hq_org_id), ' ') as hq_org_id -- 总行机构编号
    ,nvl(trim(hq_org_name), ' ') as hq_org_name -- 总行机构名称
    ,nvl(trim(brch_id), ' ') as brch_id -- 分行编号
    ,nvl(trim(brch_name), ' ') as brch_name -- 分行名称
    ,nvl(trim(subrch_id), ' ') as subrch_id -- 支行编号
    ,nvl(trim(subrch_name), ' ') as subrch_name -- 支行名称
    ,nvl(trim(org_type_cd), ' ') as org_type_cd -- 机构类型代码
    ,nvl(trim(org_lev_cd), ' ') as org_lev_cd -- 机构级别代码
    ,nvl(trim(org_status_cd), ' ') as org_status_cd -- 机构状态代码
    ,nvl(trim(bus_status_cd), ' ') as bus_status_cd -- 营业状态代码
    ,nvl(trim(bus_org_flg), ' ') as bus_org_flg -- 营业机构标志
    ,nvl(trim(enty_org_flg), ' ') as enty_org_flg -- 实体机构标志
    ,nvl(trim(accti_org_flg), ' ') as accti_org_flg -- 核算机构标志
    ,nvl(trim(admin_org_flg), ' ') as admin_org_flg -- 行政机构标志
    ,nvl(trim(acct_instit_flg), ' ') as acct_instit_flg -- 账务机构标志
    ,nvl(trim(vtual_accti_org_flg), ' ') as vtual_accti_org_flg -- 虚拟核算机构标志
    ,nvl(trim(admin_super_org_id), ' ') as admin_super_org_id -- 行政上级机构编号
    ,nvl(trim(acct_super_org_id), ' ') as acct_super_org_id -- 账务上级机构编号
    ,nvl(trim(accti_super_org_id), ' ') as accti_super_org_id -- 核算上级机构编号
    ,nvl(trim(func_org_id), ' ') as func_org_id -- 职能机构编号
    ,nvl(trim(func_dept_id), ' ') as func_dept_id -- 职能部门编号
    ,nvl(trim(cty_rg_cd), ' ') as cty_rg_cd -- 国家和地区代码
    ,nvl(trim(prov_cd), ' ') as prov_cd -- 省代码
    ,nvl(trim(city_cd), ' ') as city_cd -- 市代码
    ,nvl(trim(county_cd), ' ') as county_cd -- 县代码
    ,nvl(trim(phys_addr), ' ') as phys_addr -- 物理地址
    ,nvl(trim(ddd_area_cd), ' ') as ddd_area_cd -- 国内长途区号
    ,nvl(trim(phone), ' ') as phone -- 联系电话
    ,nvl(trim(zip_cd), ' ') as zip_cd -- 邮政编码
    ,nvl(org_found_dt, null) as org_found_dt -- 机构成立日期
    ,nvl(org_revo_dt, null) as org_revo_dt -- 机构撤销日期
    ,nvl(trim(org_start_bus_tm), ' ') as org_start_bus_tm -- 机构开始营业时间
    ,nvl(trim(org_end_bus_tm), ' ') as org_end_bus_tm -- 机构结束营业时间
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from ${msl_schema}.msl_edw_cmm_intnal_org_info
where etl_dt = to_date('${batch_date}','yyyymmdd')
 ;
commit;

-- 3 table grant
whenever sqlerror exit sql.sqlcode;
grant select on ${itl_schema}.mtl_cmm_intnal_org_info to ${iol_schema};

-- 4 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${itl_schema}',tabname => 'mtl_cmm_intnal_org_info',partname => 'p_${batch_date}', granularity => 'PARTITION', degree => 8, cascade => true);