/*
Purpose:    技术缓冲层脚本，把数据文件加载到目标表的当天分区中。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd itl_mtl_pty_emply
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
-- alter table ${itl_schema}.mtl_pty_emply drop partition p_${retain_day};  20200901去除删除策略，保留全部
alter table ${itl_schema}.mtl_pty_emply drop partition p_${batch_date};

-- 2.2 add today partition
whenever sqlerror exit sql.sqlcode;
alter table ${itl_schema}.mtl_pty_emply add  partition p_${batch_date} values (to_date('${batch_date}','yyyymmdd'));

-- 2.3 insert data target table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ into ${itl_schema}.mtl_pty_emply partition for (to_date('${batch_date}','yyyymmdd')) (
     emply_id -- 员工编号
    ,region_acct_num -- 域账号
    ,first_name -- 名字
    ,last_name -- 姓氏
    ,cert_type_cd -- 证件类型代码
    ,cert_no -- 证件号码
    ,gender_cd -- 性别代码
    ,birth_dt -- 出生日期
    ,nationty_cd -- 民族代码
    ,politic_status_cd -- 政治面貌代码
    ,marriage_situ_cd -- 婚姻状况代码
    ,edu_cd -- 学历代码
    ,join_work_dt -- 参加工作日期
    ,teller_pic_name -- 柜员图片名称
    ,emply_type_cd -- 员工类型代码
    ,belong_dept_id -- 所属部门编号
    ,postn_cd -- 职位代码
    ,teller_belong_org_id -- 柜员所属机构编号
    ,empyt_dt -- 入职日期
    ,dimission_dt -- 离职日期
    ,emply_status_cd -- 员工状态代码
    ,emply_sys_status_cd -- 员工系统状态代码
    ,fax_dom_area_cd -- 传真国内区号
    ,fax_num -- 传真号码
    ,work_tel_dom_area_cd -- 单位电话国内区号
    ,work_tel_num -- 单位电话号码
    ,mobile_phone_num -- 移动电话号码
    ,mobile_phone_num_2 -- 移动电话号码2
    ,cty_cd -- 国家代码
    ,resd_addr -- 住宅地址
    ,e_mail -- 电子邮箱
    ,salary_lev_cd -- 薪资级别代码
    ,dsply_seq_num -- 显示顺序号
    ,vtual_accti_dept_id -- 虚拟核算部门编号
    ,modif_dt -- 修改日期
    ,subsidy_distr_dt -- 补贴发放日期
    ,ding_talk_user_id -- 钉钉用户编号
    ,post_cd -- 职务代码
    ,lp_id -- 法人编号
    ,main_teller_id -- 主柜员编号
    ,title_cd -- 职称代码
    ,party_id -- 当事人编号
    ,create_dt -- 创建日期
    ,update_dt -- 更新日期
    ,id_mark -- 删除标识
    ,etl_dt -- ETL处理日期
    ,etl_timestamp -- ETL处理时间
)
select
     nvl(trim(emply_id), ' ') as emply_id -- 员工编号
    ,nvl(trim(region_acct_num), ' ') as region_acct_num -- 域账号
    ,nvl(trim(first_name), ' ') as first_name -- 名字
    ,nvl(trim(last_name), ' ') as last_name -- 姓氏
    ,nvl(trim(cert_type_cd), ' ') as cert_type_cd -- 证件类型代码
    ,nvl(trim(cert_no), ' ') as cert_no -- 证件号码
    ,nvl(trim(gender_cd), ' ') as gender_cd -- 性别代码
    ,nvl(birth_dt, null) as birth_dt -- 出生日期
    ,nvl(trim(nationty_cd), ' ') as nationty_cd -- 民族代码
    ,nvl(trim(politic_status_cd), ' ') as politic_status_cd -- 政治面貌代码
    ,nvl(trim(marriage_situ_cd), ' ') as marriage_situ_cd -- 婚姻状况代码
    ,nvl(trim(edu_cd), ' ') as edu_cd -- 学历代码
    ,nvl(join_work_dt, null) as join_work_dt -- 参加工作日期
    ,nvl(trim(teller_pic_name), ' ') as teller_pic_name -- 柜员图片名称
    ,nvl(trim(emply_type_cd), ' ') as emply_type_cd -- 员工类型代码
    ,nvl(trim(belong_dept_id), ' ') as belong_dept_id -- 所属部门编号
    ,nvl(trim(postn_cd), ' ') as postn_cd -- 职位代码
    ,nvl(trim(teller_belong_org_id), ' ') as teller_belong_org_id -- 柜员所属机构编号
    ,nvl(empyt_dt, null) as empyt_dt -- 入职日期
    ,nvl(dimission_dt, null) as dimission_dt -- 离职日期
    ,nvl(trim(emply_status_cd), ' ') as emply_status_cd -- 员工状态代码
    ,nvl(trim(emply_sys_status_cd), ' ') as emply_sys_status_cd -- 员工系统状态代码
    ,nvl(trim(fax_dom_area_cd), ' ') as fax_dom_area_cd -- 传真国内区号
    ,nvl(trim(fax_num), ' ') as fax_num -- 传真号码
    ,nvl(trim(work_tel_dom_area_cd), ' ') as work_tel_dom_area_cd -- 单位电话国内区号
    ,nvl(trim(work_tel_num), ' ') as work_tel_num -- 单位电话号码
    ,nvl(trim(mobile_phone_num), ' ') as mobile_phone_num -- 移动电话号码
    ,nvl(trim(mobile_phone_num_2), ' ') as mobile_phone_num_2 -- 移动电话号码2
    ,nvl(trim(cty_cd), ' ') as cty_cd -- 国家代码
    ,nvl(trim(resd_addr), ' ') as resd_addr -- 住宅地址
    ,nvl(trim(e_mail), ' ') as e_mail -- 电子邮箱
    ,nvl(trim(salary_lev_cd), ' ') as salary_lev_cd -- 薪资级别代码
    ,nvl(trim(dsply_seq_num), ' ') as dsply_seq_num -- 显示顺序号
    ,nvl(trim(vtual_accti_dept_id), ' ') as vtual_accti_dept_id -- 虚拟核算部门编号
    ,nvl(modif_dt, null) as modif_dt -- 修改日期
    ,nvl(subsidy_distr_dt, null) as subsidy_distr_dt -- 补贴发放日期
    ,nvl(trim(ding_talk_user_id), ' ') as ding_talk_user_id -- 钉钉用户编号
    ,nvl(trim(post_cd), ' ') as post_cd -- 职务代码
    ,nvl(trim(lp_id), ' ') as lp_id -- 法人编号
    ,nvl(trim(main_teller_id), ' ') as main_teller_id -- 主柜员编号
    ,nvl(trim(title_cd), ' ') as title_cd -- 职称代码
    ,nvl(trim(party_id), ' ') as party_id -- 当事人编号
    ,nvl(create_dt, null) as create_dt -- 创建日期
    ,nvl(update_dt, null) as update_dt -- 更新日期
    ,nvl(trim(id_mark), ' ') as id_mark -- 删除标识
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from ${msl_schema}.msl_edw_pty_emply
where etl_dt = to_date('${batch_date}','yyyymmdd')
and   id_mark<>'D' 
 ;
commit;

-- 3 table grant
whenever sqlerror exit sql.sqlcode;
grant select on ${itl_schema}.mtl_pty_emply to ${iol_schema};

-- 4 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${itl_schema}',tabname => 'mtl_pty_emply',partname => 'p_${batch_date}', granularity => 'PARTITION', degree => 8, cascade => true);