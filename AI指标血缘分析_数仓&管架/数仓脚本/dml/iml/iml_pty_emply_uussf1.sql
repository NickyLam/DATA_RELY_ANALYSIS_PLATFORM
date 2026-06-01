/*
Purpose:    整全模型层-快照表脚本，备份目标表当月数据（不含当天），用前一天数据与当天数据整合后插入到目标表中。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iml_pty_emply_uussf1
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
drop table ${iml_schema}.pty_emply_uussf1_tm purge;
drop table ${iml_schema}.pty_emply_uussf1_ex purge;

-- 2.2 add partition for target table
alter table ${iml_schema}.pty_emply add partition p_uussf1 values ('uussf1')(
        subpartition p_uussf1_${batch_date} values (to_date('${batch_date}','yyyymmdd'))
    )
;
alter table ${iml_schema}.pty_emply modify partition p_uussf1
    add subpartition p_uussf1_${batch_date} values (to_date('${batch_date}','yyyymmdd'))
;

-- 2.3 if backup table is exists, mean script if failed on last time
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
create table ${iml_schema}.pty_emply_uussf1_bk nologging
compress ${option_switch} for query high
as
select * from ${iml_schema}.pty_emply partition for ('uussf1')
where create_dt < to_date('${batch_date}','yyyymmdd')
;

-- 2.4 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.pty_emply_uussf1_tm
compress ${option_switch} for query high
as
select
    emply_id -- 员工编号
    ,lp_id -- 法人编号
    ,region_acct_num -- 域账号
    ,first_name -- 名字
    ,last_name -- 姓氏
    ,cert_type_cd -- 证件类型代码
    ,cert_no -- 证件号码
    ,gender_cd -- 员工性别代码
    ,birth_dt -- 员工出生日期
    ,nationty_cd -- 民族代码
    ,politic_status_cd -- 政治面貌代码
    ,marriage_situ_cd -- 婚姻状况代码
    ,edu_cd -- 员工学历
    ,join_work_dt -- 参加工作日期
    ,teller_pic_name -- 柜员图片名称
    ,emply_type_cd -- 员工类型代码
    ,belong_dept_id -- 所属部门编号
    ,postn_cd -- 职位代码
    ,teller_belong_org_id -- 柜员所属机构编号
    ,empyt_dt -- 员工入职日期
    ,dimission_dt -- 离职日期
    ,emply_status_cd -- 员工状态代码
    ,emply_sys_status_cd -- 员工系统状态代码
    ,fax_dom_area_cd -- 传真国内区号
    ,fax_num -- 传真号码
    ,work_tel_dom_area_cd -- 单位电话国内区号
    ,work_tel_num -- 单位电话号码
    ,mobile_phone_num -- 联系电话
    ,mobile_phone_num_2 -- 移动电话号码2
    ,cty_cd -- 员工国籍代码
    ,resd_addr -- 住宅地址
    ,e_mail -- 电子邮箱
    ,salary_lev_cd -- 薪资级别代码
    ,dsply_seq_num -- 显示顺序号
    ,vtual_accti_dept_id -- 虚拟核算部门编号
    ,modif_dt -- 修改日期
    ,subsidy_distr_dt -- 补贴发放日期
    ,ding_talk_user_id -- 钉钉用户编号
    ,post_cd -- 职务代码
    ,main_teller_id -- 主柜员编号
    ,title_cd -- 职称等级代码
    ,party_id -- 当事人编号
    ,work_tel_inter_area_cd -- 单位电话国际区号
    ,dimission_apv_status_cd -- 离职审批状态代码
    ,post_id -- 岗位编号
    ,post_descb -- 岗位描述
    ,post_type_id -- 岗位类别编号
    ,post_type_name -- 岗位类别名称
    ,etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
from ${iml_schema}.pty_emply
where 0=1;

-- 2.5 create temp table
create table ${iml_schema}.pty_emply_uussf1_ex nologging
compress ${option_switch} for query high
as select * from ${iml_schema}.pty_emply partition for ('uussf1') where 0=1;

-- 2.1 insert data to tm table
-- uuss_uus_employee-
insert into ${iml_schema}.pty_emply_uussf1_tm(
    emply_id -- 员工编号
    ,region_acct_num -- 法人编号
    ,first_name -- 域账号
    ,last_name -- 名字
    ,cert_type_cd -- 姓氏
    ,cert_no -- 证件类型代码
    ,gender_cd -- 证件号码
    ,birth_dt -- 员工性别代码
    ,nationty_cd -- 员工出生日期
    ,politic_status_cd -- 民族代码
    ,marriage_situ_cd -- 政治面貌代码
    ,edu_cd -- 婚姻状况代码
    ,join_work_dt -- 员工学历
    ,teller_pic_name -- 参加工作日期
    ,emply_type_cd -- 柜员图片名称
    ,belong_dept_id -- 员工类型代码
    ,postn_cd -- 所属部门编号
    ,teller_belong_org_id -- 职位代码
    ,empyt_dt -- 柜员所属机构编号
    ,dimission_dt -- 员工入职日期
    ,emply_status_cd -- 离职日期
    ,emply_sys_status_cd -- 员工状态代码
    ,fax_dom_area_cd -- 员工系统状态代码
    ,fax_num -- 传真国内区号
    ,work_tel_dom_area_cd -- 传真号码
    ,work_tel_num -- 单位电话国内区号
    ,mobile_phone_num -- 单位电话号码
    ,mobile_phone_num_2 -- 联系电话
    ,cty_cd -- 移动电话号码2
    ,resd_addr -- 员工国籍代码
    ,e_mail -- 住宅地址
    ,salary_lev_cd -- 电子邮箱
    ,dsply_seq_num -- 薪资级别代码
    ,vtual_accti_dept_id -- 显示顺序号
    ,modif_dt -- 虚拟核算部门编号
    ,subsidy_distr_dt -- 修改日期
    ,ding_talk_user_id -- 补贴发放日期
    ,post_cd -- 钉钉用户编号
    ,lp_id -- 职务代码
    ,main_teller_id -- 主柜员编号
    ,title_cd -- 职称等级代码
    ,party_id -- 当事人编号
    ,work_tel_inter_area_cd -- 单位电话国际区号
    ,dimission_apv_status_cd -- 离职审批状态代码
    ,post_id -- 岗位编号
    ,post_descb -- 岗位描述
    ,post_type_id -- 岗位类别编号
    ,post_type_name -- 岗位类别名称
    ,etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
)
select
    P1.EMPLOYEEID -- 员工编号
    ,P1.DOMAINID -- 法人编号
    ,P1.GIVENNAME -- 域账号
    ,P1.SURNAME -- 名字
    ,P1.IDTYPE -- 姓氏
    ,P1.IDCODE -- 证件类型代码
    ,P1.SEX -- 证件号码
    ,${iml_schema}.DATEFORMAT_MIN(P1.BIRTHDATE) -- 员工性别代码
    ,nvl(trim(P1.ETHNIC),'00') -- 民族代码
    ,P1.POLITICFACE -- 民族代码
    ,P1.MARRIAGE -- 政治面貌代码
    ,nvl(trim(P1.EDUCATION),'00') -- 婚姻状况代码
    ,${iml_schema}.DATEFORMAT_MAX(P1.JOBDATE) -- 员工学历
    ,P1.PICTUREPATH -- 参加工作日期
    ,NVL(TRIM(P1.EMPTYPE),0) -- 柜员图片名称
    ,P1.ORGANCODE -- 员工类型代码
    ,P1.PLACE -- 所属部门编号
    ,P1.ATTACHORGAN -- 职位代码
    ,${iml_schema}.DATEFORMAT_MIN(P1.THEENTRYDATE) -- 柜员所属机构编号
    ,${iml_schema}.DATEFORMAT_MAX(P1.LEAVEOFFICEDATE) -- 员工入职日期
    ,P1.STATUS -- 离职日期
    ,P1.SYSSTATUS -- 员工状态代码
    ,P1.FIXAREACODE -- 员工系统状态代码
    ,P1.FIXPHONE -- 传真国内区号
    ,P1.COMPANYAREACODE -- 传真号码
    ,P1.COMPANYPHONE -- 单位电话国内区号
    ,P1.MOBILE -- 单位电话号码
    ,P1.MOBILE1 -- 联系电话
    ,P1.COUNTRY -- 移动电话号码2
    ,P1.ADDRESS -- 员工国籍代码
    ,P1.EMAIL -- 住宅地址
    ,P1.SALLEVEL -- 电子邮箱
    ,P1.ORDERNO -- 薪资级别代码
    ,P1.HSORGANCODE -- 显示顺序号
    ,${iml_schema}.DATEFORMAT_MAX(P1.UPDATEDATE) -- 虚拟核算部门编号
    ,${iml_schema}.DATEFORMAT_MAX(P1.SUBSIDYDATE) -- 修改日期
    ,P1.USERID -- 补贴发放日期
    ,P1.PLACEHR -- 钉钉用户编号
    ,'9999' -- 职务代码
    ,P1.TELLERNO -- 主柜员编号
    ,nvl(trim(P1.TITLECODE),'99') -- 职称等级代码
    ,'201003'||P1.EMPLOYEEID -- 当事人编号
    ,P1.COMPANYCOUNTRYCODE -- 单位电话国际区号
    ,nvl(trim(P1.LEAVESTATUS),'-') -- 离职审批状态代码
    ,P1.POSTNUM -- 岗位编号
    ,P1.POSTDESC -- 岗位描述
    ,P1.POSTTYPE -- 岗位类别编号
    ,P1.POSTNAME -- 岗位类别名称
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,'uuss_uus_employee' -- 源表名称
    ,'uussf1' -- 任务编码
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间戳
from ${iol_schema}.uuss_uus_employee p1
where p1.start_dt <= to_date('${batch_date}','yyyymmdd') and p1.end_dt > to_date('${batch_date}','yyyymmdd')
;
commit;


commit;



whenever sqlerror exit sql.sqlcode;
declare
cnt integer;
begin
  for cur in (select 1 from dual) loop
  	select count(1) into cnt from (select 1 from ${iml_schema}.pty_emply_uussf1_tm 
  	                                group by 
  	                                        emply_id
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
insert /*+ append */ into ${iml_schema}.pty_emply_uussf1_ex(
    emply_id -- 员工编号
    ,lp_id -- 法人编号
    ,region_acct_num -- 域账号
    ,first_name -- 名字
    ,last_name -- 姓氏
    ,cert_type_cd -- 证件类型代码
    ,cert_no -- 证件号码
    ,gender_cd -- 员工性别代码
    ,birth_dt -- 员工出生日期
    ,nationty_cd -- 民族代码
    ,politic_status_cd -- 政治面貌代码
    ,marriage_situ_cd -- 婚姻状况代码
    ,edu_cd -- 员工学历
    ,join_work_dt -- 参加工作日期
    ,teller_pic_name -- 柜员图片名称
    ,emply_type_cd -- 员工类型代码
    ,belong_dept_id -- 所属部门编号
    ,postn_cd -- 职位代码
    ,teller_belong_org_id -- 柜员所属机构编号
    ,empyt_dt -- 员工入职日期
    ,dimission_dt -- 离职日期
    ,emply_status_cd -- 员工状态代码
    ,emply_sys_status_cd -- 员工系统状态代码
    ,fax_dom_area_cd -- 传真国内区号
    ,fax_num -- 传真号码
    ,work_tel_dom_area_cd -- 单位电话国内区号
    ,work_tel_num -- 单位电话号码
    ,mobile_phone_num -- 联系电话
    ,mobile_phone_num_2 -- 移动电话号码2
    ,cty_cd -- 员工国籍代码
    ,resd_addr -- 住宅地址
    ,e_mail -- 电子邮箱
    ,salary_lev_cd -- 薪资级别代码
    ,dsply_seq_num -- 显示顺序号
    ,vtual_accti_dept_id -- 虚拟核算部门编号
    ,modif_dt -- 修改日期
    ,subsidy_distr_dt -- 补贴发放日期
    ,ding_talk_user_id -- 钉钉用户编号
    ,post_cd -- 职务代码
    ,main_teller_id -- 主柜员编号
    ,title_cd -- 职称等级代码
    ,party_id -- 当事人编号
    ,work_tel_inter_area_cd -- 单位电话国际区号
    ,dimission_apv_status_cd -- 离职审批状态代码
    ,post_id -- 岗位编号
    ,post_descb -- 岗位描述
    ,post_type_id -- 岗位类别编号
    ,post_type_name -- 岗位类别名称
    ,create_dt -- 创建日期
    ,update_dt -- 更新日期
    ,etl_dt -- ETL处理日期
    ,id_mark -- 增删标志
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
)
select
    nvl(n.emply_id, o.emply_id) as emply_id -- 员工编号
    ,nvl(n.lp_id, o.lp_id) as lp_id -- 法人编号
    ,nvl(n.region_acct_num, o.region_acct_num) as region_acct_num -- 域账号
    ,nvl(n.first_name, o.first_name) as first_name -- 名字
    ,nvl(n.last_name, o.last_name) as last_name -- 姓氏
    ,nvl(n.cert_type_cd, o.cert_type_cd) as cert_type_cd -- 证件类型代码
    ,nvl(n.cert_no, o.cert_no) as cert_no -- 证件号码
    ,nvl(n.gender_cd, o.gender_cd) as gender_cd -- 员工性别代码
    ,nvl(n.birth_dt, o.birth_dt) as birth_dt -- 员工出生日期
    ,nvl(n.nationty_cd, o.nationty_cd) as nationty_cd -- 民族代码
    ,nvl(n.politic_status_cd, o.politic_status_cd) as politic_status_cd -- 政治面貌代码
    ,nvl(n.marriage_situ_cd, o.marriage_situ_cd) as marriage_situ_cd -- 婚姻状况代码
    ,nvl(n.edu_cd, o.edu_cd) as edu_cd -- 员工学历
    ,nvl(n.join_work_dt, o.join_work_dt) as join_work_dt -- 参加工作日期
    ,nvl(n.teller_pic_name, o.teller_pic_name) as teller_pic_name -- 柜员图片名称
    ,nvl(n.emply_type_cd, o.emply_type_cd) as emply_type_cd -- 员工类型代码
    ,nvl(n.belong_dept_id, o.belong_dept_id) as belong_dept_id -- 所属部门编号
    ,nvl(n.postn_cd, o.postn_cd) as postn_cd -- 职位代码
    ,nvl(n.teller_belong_org_id, o.teller_belong_org_id) as teller_belong_org_id -- 柜员所属机构编号
    ,nvl(n.empyt_dt, o.empyt_dt) as empyt_dt -- 员工入职日期
    ,nvl(n.dimission_dt, o.dimission_dt) as dimission_dt -- 离职日期
    ,nvl(n.emply_status_cd, o.emply_status_cd) as emply_status_cd -- 员工状态代码
    ,nvl(n.emply_sys_status_cd, o.emply_sys_status_cd) as emply_sys_status_cd -- 员工系统状态代码
    ,nvl(n.fax_dom_area_cd, o.fax_dom_area_cd) as fax_dom_area_cd -- 传真国内区号
    ,nvl(n.fax_num, o.fax_num) as fax_num -- 传真号码
    ,nvl(n.work_tel_dom_area_cd, o.work_tel_dom_area_cd) as work_tel_dom_area_cd -- 单位电话国内区号
    ,nvl(n.work_tel_num, o.work_tel_num) as work_tel_num -- 单位电话号码
    ,nvl(n.mobile_phone_num, o.mobile_phone_num) as mobile_phone_num -- 联系电话
    ,nvl(n.mobile_phone_num_2, o.mobile_phone_num_2) as mobile_phone_num_2 -- 移动电话号码2
    ,nvl(n.cty_cd, o.cty_cd) as cty_cd -- 员工国籍代码
    ,nvl(n.resd_addr, o.resd_addr) as resd_addr -- 住宅地址
    ,nvl(n.e_mail, o.e_mail) as e_mail -- 电子邮箱
    ,nvl(n.salary_lev_cd, o.salary_lev_cd) as salary_lev_cd -- 薪资级别代码
    ,nvl(n.dsply_seq_num, o.dsply_seq_num) as dsply_seq_num -- 显示顺序号
    ,nvl(n.vtual_accti_dept_id, o.vtual_accti_dept_id) as vtual_accti_dept_id -- 虚拟核算部门编号
    ,nvl(n.modif_dt, o.modif_dt) as modif_dt -- 修改日期
    ,nvl(n.subsidy_distr_dt, o.subsidy_distr_dt) as subsidy_distr_dt -- 补贴发放日期
    ,nvl(n.ding_talk_user_id, o.ding_talk_user_id) as ding_talk_user_id -- 钉钉用户编号
    ,nvl(n.post_cd, o.post_cd) as post_cd -- 职务代码
    ,nvl(n.main_teller_id, o.main_teller_id) as main_teller_id -- 主柜员编号
    ,nvl(n.title_cd, o.title_cd) as title_cd -- 职称等级代码
    ,nvl(n.party_id, o.party_id) as party_id -- 当事人编号
    ,nvl(n.work_tel_inter_area_cd, o.work_tel_inter_area_cd) as work_tel_inter_area_cd -- 单位电话国际区号
    ,nvl(n.dimission_apv_status_cd, o.dimission_apv_status_cd) as dimission_apv_status_cd -- 离职审批状态代码
    ,nvl(n.post_id, o.post_id) as post_id -- 岗位编号
    ,nvl(n.post_descb, o.post_descb) as post_descb -- 岗位描述
    ,nvl(n.post_type_id, o.post_type_id) as post_type_id -- 岗位类别编号
    ,nvl(n.post_type_name, o.post_type_name) as post_type_name -- 岗位类别名称
    ,nvl(o.create_dt, to_date('${batch_date}', 'yyyymmdd')) as create_dt -- 创建日期
    ,case when (
                o.emply_id is null
                and o.lp_id is null
            ) or (
                o.region_acct_num <> n.region_acct_num
                or o.first_name <> n.first_name
                or o.last_name <> n.last_name
                or o.cert_type_cd <> n.cert_type_cd
                or o.cert_no <> n.cert_no
                or o.gender_cd <> n.gender_cd
                or o.birth_dt <> n.birth_dt
                or o.nationty_cd <> n.nationty_cd
                or o.politic_status_cd <> n.politic_status_cd
                or o.marriage_situ_cd <> n.marriage_situ_cd
                or o.edu_cd <> n.edu_cd
                or o.join_work_dt <> n.join_work_dt
                or o.teller_pic_name <> n.teller_pic_name
                or o.emply_type_cd <> n.emply_type_cd
                or o.belong_dept_id <> n.belong_dept_id
                or o.postn_cd <> n.postn_cd
                or o.teller_belong_org_id <> n.teller_belong_org_id
                or o.empyt_dt <> n.empyt_dt
                or o.dimission_dt <> n.dimission_dt
                or o.emply_status_cd <> n.emply_status_cd
                or o.emply_sys_status_cd <> n.emply_sys_status_cd
                or o.fax_dom_area_cd <> n.fax_dom_area_cd
                or o.fax_num <> n.fax_num
                or o.work_tel_dom_area_cd <> n.work_tel_dom_area_cd
                or o.work_tel_num <> n.work_tel_num
                or o.mobile_phone_num <> n.mobile_phone_num
                or o.mobile_phone_num_2 <> n.mobile_phone_num_2
                or o.cty_cd <> n.cty_cd
                or o.resd_addr <> n.resd_addr
                or o.e_mail <> n.e_mail
                or o.salary_lev_cd <> n.salary_lev_cd
                or o.dsply_seq_num <> n.dsply_seq_num
                or o.vtual_accti_dept_id <> n.vtual_accti_dept_id
                or o.modif_dt <> n.modif_dt
                or o.subsidy_distr_dt <> n.subsidy_distr_dt
                or o.ding_talk_user_id <> n.ding_talk_user_id
                or o.post_cd <> n.post_cd
                or o.main_teller_id <> n.main_teller_id
                or o.title_cd <> n.title_cd
                or o.party_id <> n.party_id
                or o.work_tel_inter_area_cd <> n.work_tel_inter_area_cd
                or o.dimission_apv_status_cd <> n.dimission_apv_status_cd
                or o.post_id <> n.post_id
                or o.post_descb <> n.post_descb
                or o.post_type_id <> n.post_type_id
                or o.post_type_name <> n.post_type_name
            ) or (
                 case when (
                           n.emply_id is null
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
                n.emply_id is null
                and n.lp_id is null
            )
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,nvl(n.src_table_name, o.src_table_name) as src_table_name -- 源表名称
    ,nvl(n.job_cd, o.job_cd) as job_cd -- 任务编码
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间戳
from ${iml_schema}.pty_emply_uussf1_tm n
    full join ${iml_schema}.pty_emply_uussf1_bk o
        on
            o.emply_id = n.emply_id
            and o.lp_id = n.lp_id
;
commit;

-- 3.1 truncate target table batch_date partition
whenever sqlerror exit sql.sqlcode;
alter table ${iml_schema}.pty_emply truncate partition for ('uussf1') reuse storage;

-- 3.2 exchage tm table and target table
alter table ${iml_schema}.pty_emply exchange subpartition p_uussf1_${batch_date} with table ${iml_schema}.pty_emply_uussf1_ex;

-- 3.3 drop subpartition last_date partition
whenever sqlerror continue none ;
alter table ${iml_schema}.pty_emply drop subpartition p_uussf1_${last_date} update global indexes;

-- 4.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iml_schema}.pty_emply to ${iml_schema};

-- 4.2 drop tm table
drop table ${iml_schema}.pty_emply_uussf1_tm purge;
drop table ${iml_schema}.pty_emply_uussf1_ex purge;
drop table ${iml_schema}.pty_emply_uussf1_bk purge;

-- 5 gater table status
exec dbms_stats.gather_table_stats(ownname => '${iml_schema}',tabname => 'pty_emply', partname => 'p_uussf1_${batch_date}', ESTIMATE_PERCENT=>10, method_opt=>'for all columns size 1',no_invalidate=>false, force=>true, granularity => 'SUBPARTITION', degree => 8, cascade => true);