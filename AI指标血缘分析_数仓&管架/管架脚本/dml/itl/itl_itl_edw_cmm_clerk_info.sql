/*
Purpose:    技术缓冲层脚本，把数据文件加载到目标表的当天分区中。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd itl_itl_edw_cmm_clerk_info
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
--alter table ${itl_schema}.itl_edw_cmm_clerk_info drop partition p_${retain_day};
alter table ${itl_schema}.itl_edw_cmm_clerk_info drop partition p_${batch_date};

-- 2.2 add today partition
whenever sqlerror exit sql.sqlcode;
alter table ${itl_schema}.itl_edw_cmm_clerk_info add  partition p_${batch_date} values (to_date('${batch_date}','yyyymmdd'));

-- 2.3 insert data target table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ into ${itl_schema}.itl_edw_cmm_clerk_info partition for (to_date('${batch_date}','yyyymmdd')) (
    lp_id -- 法人编号
    ,clerk_id -- 行员编号
    ,clerk_name -- 行员名称
    ,teller_flg -- 柜员标志
    ,teller_id -- 柜员编号
    ,region_acct_num -- 域账号
    ,emply_type_cd -- 员工类型代码
    ,cert_type_cd -- 证件类型代码
    ,cert_no -- 证件号码
    ,gender_cd -- 性别代码
    ,birth_dt -- 出生日期
    ,nationty_cd -- 民族代码
    ,politic_status_cd -- 政治面貌代码
    ,marriage_situ_cd -- 婚姻状况代码
    ,edu_cd -- 学历代码
    ,post_cd -- 职务代码
    ,title_cd -- 职称代码
    ,fir_work_dt -- 首次工作日期
    ,empyt_dt -- 入职日期
    ,local_dept_id -- 所在部门编号
    ,dimission_dt -- 离职日期
    ,emply_status_cd -- 员工状态代码
    ,emply_sys_status_cd -- 员工系统状态代码
    ,belong_org_id -- 所属机构编号
    ,work_tel_inter_area_cd -- 单位电话国际区号
    ,work_tel_area_cd -- 单位电话区号
    ,work_tel_num -- 单位电话号码
    ,fax_area_cd -- 传真区号
    ,fax_num -- 传真号码
    ,mobile_phone_num -- 移动电话号码
    ,cty_cd -- 国家代码
    ,dtl_addr -- 详细地址
    ,e_mail_addr -- 电子邮箱地址
    ,ding_talk_user_id -- 钉钉用户编号
    ,jobs_cd -- 岗位代码
    ,jobs_cate -- 岗位类别
    ,jobs_name -- 岗位名称
    ,cust_mgr_flg -- 客户经理标志
    ,cust_mgr_lev -- 客户经理级别
    ,teller_lev_cd -- 柜员级别代码
    ,teller_director_id -- 柜员主管编号
    ,vtual_accti_org_id -- 虚拟核算机构编号
    ,work_tel_ext_num -- 单位电话分机号
    ,fax_inter_area_cd -- 传真国际区号
    ,fax_ext_num -- 传真分机号
    ,resd_tel_inter_area_cd -- 住宅电话国际区号
    ,resd_tel_dom_area_cd -- 住宅电话国内区号
    ,resd_tel -- 住宅电话
    ,resd_tel_ext_num -- 住宅电话分机号
    ,mobile_phone_num_1 -- 移动电话号码1
    ,mobile_phone_num_2 -- 移动电话号码2
    ,mobile_phone_num_3 -- 移动电话号码3
    ,zip_cd -- 邮政编码
    ,local_prov -- 所在省份
    ,site -- 所在地区
    ,postn_cd -- 职位代码
    ,post_cate_id -- 职务类别编号
    ,post_name -- 职务名称
    ,jobs_id -- 岗位编号
    ,jobs_descb -- 岗位描述
    ,etl_dt -- ETL处理日期
    ,etl_timestamp -- ETL处理时间
)
select
    nvl(trim(lp_id), ' ') as lp_id -- 法人编号
    ,nvl(trim(clerk_id), ' ') as clerk_id -- 行员编号
    ,nvl(trim(clerk_name), ' ') as clerk_name -- 行员名称
    ,nvl(trim(teller_flg), ' ') as teller_flg -- 柜员标志
    ,nvl(trim(teller_id), ' ') as teller_id -- 柜员编号
    ,nvl(trim(region_acct_num), ' ') as region_acct_num -- 域账号
    ,nvl(trim(emply_type_cd), ' ') as emply_type_cd -- 员工类型代码
    ,nvl(trim(cert_type_cd), ' ') as cert_type_cd -- 证件类型代码
    ,nvl(trim(cert_no), ' ') as cert_no -- 证件号码
    ,nvl(trim(gender_cd), ' ') as gender_cd -- 性别代码
    ,nvl(birth_dt, to_date('00010101', 'yyyymmdd')) as birth_dt -- 出生日期
    ,nvl(trim(nationty_cd), ' ') as nationty_cd -- 民族代码
    ,nvl(trim(politic_status_cd), ' ') as politic_status_cd -- 政治面貌代码
    ,nvl(trim(marriage_situ_cd), ' ') as marriage_situ_cd -- 婚姻状况代码
    ,nvl(trim(edu_cd), ' ') as edu_cd -- 学历代码
    ,nvl(trim(post_cd), ' ') as post_cd -- 职务代码
    ,nvl(trim(title_cd), ' ') as title_cd -- 职称代码
    ,nvl(fir_work_dt, to_date('00010101', 'yyyymmdd')) as fir_work_dt -- 首次工作日期
    ,nvl(empyt_dt, to_date('00010101', 'yyyymmdd')) as empyt_dt -- 入职日期
    ,nvl(trim(local_dept_id), ' ') as local_dept_id -- 所在部门编号
    ,nvl(dimission_dt, to_date('00010101', 'yyyymmdd')) as dimission_dt -- 离职日期
    ,nvl(trim(emply_status_cd), ' ') as emply_status_cd -- 员工状态代码
    ,nvl(trim(emply_sys_status_cd), ' ') as emply_sys_status_cd -- 员工系统状态代码
    ,nvl(trim(belong_org_id), ' ') as belong_org_id -- 所属机构编号
    ,nvl(trim(work_tel_inter_area_cd), ' ') as work_tel_inter_area_cd -- 单位电话国际区号
    ,nvl(trim(work_tel_area_cd), ' ') as work_tel_area_cd -- 单位电话区号
    ,nvl(trim(work_tel_num), ' ') as work_tel_num -- 单位电话号码
    ,nvl(trim(fax_area_cd), ' ') as fax_area_cd -- 传真区号
    ,nvl(trim(fax_num), ' ') as fax_num -- 传真号码
    ,nvl(trim(mobile_phone_num), ' ') as mobile_phone_num -- 移动电话号码
    ,nvl(trim(cty_cd), ' ') as cty_cd -- 国家代码
    ,nvl(trim(dtl_addr), ' ') as dtl_addr -- 详细地址
    ,nvl(trim(e_mail_addr), ' ') as e_mail_addr -- 电子邮箱地址
    ,nvl(trim(ding_talk_user_id), ' ') as ding_talk_user_id -- 钉钉用户编号
    ,nvl(trim(jobs_cd), ' ') as jobs_cd -- 岗位代码
    ,nvl(trim(jobs_cate), ' ') as jobs_cate -- 岗位类别
    ,nvl(trim(jobs_name), ' ') as jobs_name -- 岗位名称
    ,nvl(trim(cust_mgr_flg), ' ') as cust_mgr_flg -- 客户经理标志
    ,nvl(trim(cust_mgr_lev), ' ') as cust_mgr_lev -- 客户经理级别
    ,nvl(trim(teller_lev_cd), ' ') as teller_lev_cd -- 柜员级别代码
    ,nvl(trim(teller_director_id), ' ') as teller_director_id -- 柜员主管编号
    ,nvl(trim(vtual_accti_org_id), ' ') as vtual_accti_org_id -- 虚拟核算机构编号
    ,nvl(trim(work_tel_ext_num), ' ') as work_tel_ext_num -- 单位电话分机号
    ,nvl(trim(fax_inter_area_cd), ' ') as fax_inter_area_cd -- 传真国际区号
    ,nvl(trim(fax_ext_num), ' ') as fax_ext_num -- 传真分机号
    ,nvl(trim(resd_tel_inter_area_cd), ' ') as resd_tel_inter_area_cd -- 住宅电话国际区号
    ,nvl(trim(resd_tel_dom_area_cd), ' ') as resd_tel_dom_area_cd -- 住宅电话国内区号
    ,nvl(trim(resd_tel), ' ') as resd_tel -- 住宅电话
    ,nvl(trim(resd_tel_ext_num), ' ') as resd_tel_ext_num -- 住宅电话分机号
    ,nvl(trim(mobile_phone_num_1), ' ') as mobile_phone_num_1 -- 移动电话号码1
    ,nvl(trim(mobile_phone_num_2), ' ') as mobile_phone_num_2 -- 移动电话号码2
    ,nvl(trim(mobile_phone_num_3), ' ') as mobile_phone_num_3 -- 移动电话号码3
    ,nvl(trim(zip_cd), ' ') as zip_cd -- 邮政编码
    ,nvl(trim(local_prov), ' ') as local_prov -- 所在省份
    ,nvl(trim(site), ' ') as site -- 所在地区
    ,nvl(trim(postn_cd), ' ') as postn_cd -- 职位代码
    ,nvl(trim(post_cate_id), ' ') as post_cate_id -- 职务类别编号
    ,nvl(trim(post_name), ' ') as post_name -- 职务名称
    ,nvl(trim(jobs_id), ' ') as jobs_id -- 岗位编号
    ,nvl(trim(jobs_descb), ' ') as jobs_descb -- 岗位描述
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from ${msl_schema}.msl_edw_cmm_clerk_info
where 1=1
 ;
commit;

-- 3 table grant
whenever sqlerror exit sql.sqlcode;
grant select on ${itl_schema}.itl_edw_cmm_clerk_info to ${iol_schema};

-- 4 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${itl_schema}',tabname => 'itl_edw_cmm_clerk_info',partname => 'p_${batch_date}', granularity => 'PARTITION', degree => 8, cascade => true);