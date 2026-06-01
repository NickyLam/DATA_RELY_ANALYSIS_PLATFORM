/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_uuss_uus_employee
CreateDate: 20180515
Logs:
    zjj 2018-05-15 新建脚本
*/

set timing on

-- 1.1 alter parallel
alter session force parallel query parallel 3;
alter session force parallel dml parallel 3;

declare
  v_var    number(3)  :=0;
  v_sql    varchar2(1000);
  
begin
  for tb in (SELECT TO_CHAR(END_DT, 'yyyymmdd') as end_dt
               FROM (SELECT END_DT,
                            ROW_NUMBER() OVER(PARTITION BY END_DT ORDER BY END_DT) RN
                       FROM uuss_uus_employee_bak${batch_date})
              WHERE RN = 1
 ) loop

  select count(partition_name) into v_var 
    from user_tab_partitions 
   where substr(partition_name,3) = tb.end_dt 
     and table_name = upper('uuss_uus_employee');
  
  if v_var <> 0 then 
    execute immediate 'alter table uuss_uus_employee drop partition p_' || tb.end_dt;
  end if;
  
    v_sql :='alter table uuss_uus_employee add partition p_' || tb.end_dt || ' values(to_date(' || tb.end_dt || ',''yyyymmdd''))';
    
    execute immediate v_sql;

  
   -- 回插所有数据    
  
insert /*+ append */ into ${iol_schema}.uuss_uus_employee(
            employeeid -- 员工编号
            ,domainid -- 域帐号
            ,tellerno -- 柜员号
            ,givenname -- 名字
            ,surname -- 姓氏
            ,firstname -- 英文名字
            ,lastname -- 英文姓氏
            ,idtype -- 证件类型
            ,idcode -- 证件号码
            ,sex -- 性别
            ,birthdate -- 出生日期
            ,ethnic -- 民族
            ,politicface -- 政治面貌
            ,marriage -- 婚姻状况
            ,education -- 学历
            ,jobdate -- 参加工作日期
            ,picturepath -- 柜员图片路径
            ,emptype -- 员工类型
            ,organcode -- 所在部门编号
            ,titlecode -- 职称
            ,place -- 职位
            ,managertype -- 客户经理标志
            ,managerlevel -- 客户经理级别
            ,tellerlevel -- 柜员级别
            ,tellermanagerid -- 柜员主管编号
            ,attachorgan -- 柜员所属机构
            ,theentrydate -- 入职日期
            ,leaveofficedate -- 离职日期
            ,status -- 员工状态
            ,sysstatus -- 用户系统状态
            ,fixcountrycode -- 传真国际区号
            ,fixareacode -- 传真国内区号
            ,fixphone -- 传真
            ,fixsubphone -- 传真分机号
            ,companycountrycode -- 单位电话国际区号
            ,companyareacode -- 单位电话国内区号
            ,companyphone -- 单位电话
            ,companysubphone -- 单位电话分机号
            ,housecountrycode -- 住宅电话国际区号
            ,houseareacode -- 住宅电话国内区号
            ,homephone -- 住宅电话
            ,housesubphone -- 住宅电话分机号
            ,mobile -- 移动电话
            ,mobile1 -- 移动电话1
            ,mobile2 -- 移动电话2
            ,mobile3 -- 移动电话3
            ,post -- 邮政编码
            ,country -- 所在国家
            ,province -- 所在省/州
            ,city -- 所在城市
            ,county -- 县/区代码
            ,address -- 详细地址
            ,email -- 电子邮箱
            ,sallevel -- 薪资级别
            ,orderno -- 显示顺序号
            ,hsorgancode -- 虚拟核算部门编号
            ,updatedate -- 更新日期
            ,subsidydate -- 补贴正式发放日期
            ,userid -- 钉钉UserID
            ,placehr -- 职务
            ,jobcategory -- （职务类别）员工职务代码
            ,tellerstatus -- 柜员状态
            ,leavestatus -- 离职审批中（在岗）2-离职审批中（不在岗）职审批状态(1-离职审批中（在岗）2-离职审批中（不在岗）)
            ,postnum -- 具体岗位编号
            ,postdesc -- 具体岗位描述
			,posttype -- 岗位类别
            ,postname -- 岗位名称
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
            employeeid -- 员工编号
            ,domainid -- 域帐号
            ,tellerno -- 柜员号
            ,givenname -- 名字
            ,surname -- 姓氏
            ,firstname -- 英文名字
            ,lastname -- 英文姓氏
            ,idtype -- 证件类型
            ,idcode -- 证件号码
            ,sex -- 性别
            ,birthdate -- 出生日期
            ,ethnic -- 民族
            ,politicface -- 政治面貌
            ,marriage -- 婚姻状况
            ,education -- 学历
            ,jobdate -- 参加工作日期
            ,picturepath -- 柜员图片路径
            ,emptype -- 员工类型
            ,organcode -- 所在部门编号
            ,titlecode -- 职称
            ,place -- 职位
            ,managertype -- 客户经理标志
            ,managerlevel -- 客户经理级别
            ,tellerlevel -- 柜员级别
            ,tellermanagerid -- 柜员主管编号
            ,attachorgan -- 柜员所属机构
            ,theentrydate -- 入职日期
            ,leaveofficedate -- 离职日期
            ,status -- 员工状态
            ,sysstatus -- 用户系统状态
            ,fixcountrycode -- 传真国际区号
            ,fixareacode -- 传真国内区号
            ,fixphone -- 传真
            ,fixsubphone -- 传真分机号
            ,companycountrycode -- 单位电话国际区号
            ,companyareacode -- 单位电话国内区号
            ,companyphone -- 单位电话
            ,companysubphone -- 单位电话分机号
            ,housecountrycode -- 住宅电话国际区号
            ,houseareacode -- 住宅电话国内区号
            ,homephone -- 住宅电话
            ,housesubphone -- 住宅电话分机号
            ,mobile -- 移动电话
            ,mobile1 -- 移动电话1
            ,mobile2 -- 移动电话2
            ,mobile3 -- 移动电话3
            ,post -- 邮政编码
            ,country -- 所在国家
            ,province -- 所在省/州
            ,city -- 所在城市
            ,county -- 县/区代码
            ,address -- 详细地址
            ,email -- 电子邮箱
            ,sallevel -- 薪资级别
            ,orderno -- 显示顺序号
            ,hsorgancode -- 虚拟核算部门编号
            ,updatedate -- 更新日期
            ,subsidydate -- 补贴正式发放日期
            ,userid -- 钉钉UserID
            ,placehr -- 职务
            ,jobcategory -- （职务类别）员工职务代码
            ,tellerstatus -- 柜员状态
            ,leavestatus -- 离职审批中（在岗）2-离职审批中（不在岗）职审批状态(1-离职审批中（在岗）2-离职审批中（不在岗）)
            ,postnum -- 具体岗位编号
            ,postdesc -- 具体岗位描述
			,' ' as posttype -- 岗位类别
            ,' ' as postname -- 岗位名称
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
from ${iol_schema}.uuss_uus_employee_bak${batch_date}
where end_dt = to_date(tb.end_dt,'yyyymmdd');
commit;

end loop;
end;
/
