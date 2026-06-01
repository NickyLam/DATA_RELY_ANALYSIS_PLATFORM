/*
Purpose:    应用集市层-建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd idl_aml_pty_emply
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
alter table ${idl_schema}.aml_pty_emply drop partition p_${last_date};
alter table ${idl_schema}.aml_pty_emply drop partition p_${batch_date};

-- 2.2 add today partition
whenever sqlerror exit sql.sqlcode;
alter table ${idl_schema}.aml_pty_emply add  partition p_${batch_date} values (to_date('${batch_date}','yyyymmdd'));

-- 2.3 insert data target table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ into ${idl_schema}.aml_pty_emply partition for (to_date('${batch_date}','yyyymmdd')) (
    emply_id  -- 员工编号
    ,region_acct_num  -- 域账号
    ,first_name  -- 名字
    ,last_name  -- 姓氏
    ,cert_type_cd  -- 证件类型代码
    ,cert_no  -- 证件号码
    ,gender_cd  -- 性别代码
    ,birth_dt  -- 出生日期
    ,nationty_cd  -- 民族代码
    ,politic_status_cd  -- 政治面貌代码
    ,marriage_situ_cd  -- 婚姻状况代码
    ,edu_cd  -- 学历代码
    ,join_work_dt  -- 参加工作日期
    ,teller_pic_name  -- 柜员图片名称
    ,emply_type_cd  -- 员工类型代码
    ,belong_dept_id  -- 所属部门编号
    ,postn_cd  -- 职位代码
    ,teller_belong_org_id  -- 柜员所属机构编号
    ,empyt_dt  -- 入职日期
    ,dimission_dt  -- 离职日期
    ,emply_status_cd  -- 员工状态代码
    ,emply_sys_status_cd  -- 员工系统状态代码
    ,fax_dom_area_cd  -- 传真国内区号
    ,fax_num  -- 传真号码
    ,work_tel_dom_area_cd  -- 单位电话国内区号
    ,work_tel_num  -- 单位电话号码
    ,mobile_phone_num  -- 移动电话号码
    ,mobile_phone_num_2  -- 移动电话号码2
    ,cty_cd  -- 国家代码
    ,resd_addr  -- 住宅地址
    ,e_mail  -- 电子邮箱
    ,salary_lev_cd  -- 薪资级别代码
    ,dsply_seq_num  -- 显示顺序号
    ,vtual_accti_dept_id  -- 虚拟核算部门编号
    ,modif_dt  -- 修改日期
    ,subsidy_distr_dt  -- 补贴发放日期
    ,ding_talk_user_id  -- 钉钉用户编号
    ,post_cd  -- 职务代码
    ,create_dt  -- 创建日期
    ,update_dt  -- 更新日期
    ,etl_dt  -- 数据日期
    ,id_mark  -- 删除标识
    ,src_table_name  -- 源表名称
    ,job_cd  -- 任务代码
    ,etl_timestamp  -- 数据处理时间
)
select
    replace(replace(t1.emply_id,chr(13),''),chr(10),'')  -- 员工编号
    ,replace(replace(t1.region_acct_num,chr(13),''),chr(10),'')  -- 域账号
    ,replace(replace(t1.first_name,chr(13),''),chr(10),'')  -- 名字
    ,replace(replace(t1.last_name,chr(13),''),chr(10),'')  -- 姓氏
    ,replace(replace(t1.cert_type_cd,chr(13),''),chr(10),'')  -- 证件类型代码
    ,replace(replace(t1.cert_no,chr(13),''),chr(10),'')  -- 证件号码
    ,replace(replace(t1.gender_cd,chr(13),''),chr(10),'')  -- 性别代码
    ,t1.birth_dt  -- 出生日期
    ,replace(replace(t1.nationty_cd,chr(13),''),chr(10),'')  -- 民族代码
    ,replace(replace(t1.politic_status_cd,chr(13),''),chr(10),'')  -- 政治面貌代码
    ,replace(replace(t1.marriage_situ_cd,chr(13),''),chr(10),'')  -- 婚姻状况代码
    ,replace(replace(t1.edu_cd,chr(13),''),chr(10),'')  -- 学历代码
    ,t1.join_work_dt  -- 参加工作日期
    ,replace(replace(t1.teller_pic_name,chr(13),''),chr(10),'')  -- 柜员图片名称
    ,replace(replace(t1.emply_type_cd,chr(13),''),chr(10),'')  -- 员工类型代码
    ,replace(replace(t1.belong_dept_id,chr(13),''),chr(10),'')  -- 所属部门编号
    ,replace(replace(t1.postn_cd,chr(13),''),chr(10),'')  -- 职位代码
    ,replace(replace(t1.teller_belong_org_id,chr(13),''),chr(10),'')  -- 柜员所属机构编号
    ,t1.empyt_dt  -- 入职日期
    ,t1.dimission_dt  -- 离职日期
    ,replace(replace(t1.emply_status_cd,chr(13),''),chr(10),'')  -- 员工状态代码
    ,replace(replace(t1.emply_sys_status_cd,chr(13),''),chr(10),'')  -- 员工系统状态代码
    ,replace(replace(t1.fax_dom_area_cd,chr(13),''),chr(10),'')  -- 传真国内区号
    ,replace(replace(t1.fax_num,chr(13),''),chr(10),'')  -- 传真号码
    ,replace(replace(t1.work_tel_dom_area_cd,chr(13),''),chr(10),'')  -- 单位电话国内区号
    ,replace(replace(t1.work_tel_num,chr(13),''),chr(10),'')  -- 单位电话号码
    ,replace(replace(t1.mobile_phone_num,chr(13),''),chr(10),'')  -- 移动电话号码
    ,replace(replace(t1.mobile_phone_num_2,chr(13),''),chr(10),'')  -- 移动电话号码2
    ,replace(replace(t1.cty_cd,chr(13),''),chr(10),'')  -- 国家代码
    ,replace(replace(t1.resd_addr,chr(13),''),chr(10),'')  -- 住宅地址
    ,replace(replace(t1.e_mail,chr(13),''),chr(10),'')  -- 电子邮箱
    ,replace(replace(t1.salary_lev_cd,chr(13),''),chr(10),'')  -- 薪资级别代码
    ,replace(replace(t1.dsply_seq_num,chr(13),''),chr(10),'')  -- 显示顺序号
    ,replace(replace(t1.vtual_accti_dept_id,chr(13),''),chr(10),'')  -- 虚拟核算部门编号
    ,t1.modif_dt  -- 修改日期
    ,t1.subsidy_distr_dt  -- 补贴发放日期
    ,replace(replace(t1.ding_talk_user_id,chr(13),''),chr(10),'')  -- 钉钉用户编号
    ,replace(replace(t1.post_cd,chr(13),''),chr(10),'')  -- 职务代码
    ,t1.create_dt  -- 创建日期
    ,t1.update_dt  -- 更新日期
    ,to_date('${batch_date}','yyyymmdd') as etl_dt  -- 数据日期
    ,replace(replace(t1.id_mark,chr(13),''),chr(10),'')  -- 删除标识
    ,replace(replace(t1.src_table_name,chr(13),''),chr(10),'')  -- 源表名称
    ,replace(replace(t1.job_cd,chr(13),''),chr(10),'')  -- 任务代码
    ,t1.etl_timestamp  -- 数据处理时间
from ${iml_schema}.pty_emply t1    --员工
where t1.create_dt <=to_date('${batch_date}','yyyymmdd') and t1.id_mark <> 'D' ;
commit;


-- 4 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${idl_schema}',tabname => 'aml_pty_emply',partname => 'p_${batch_date}', granularity => 'PARTITION', degree => 8, cascade => true);