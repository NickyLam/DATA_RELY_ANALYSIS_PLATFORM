/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_bdps_branch_info
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
                       FROM bdps_branch_info_bak${batch_date})
              WHERE RN = 1
 ) loop

  select count(partition_name) into v_var 
    from user_tab_partitions 
   where substr(partition_name,3) = tb.end_dt 
     and table_name = upper('bdps_branch_info');
  
  if v_var <> 0 then 
    execute immediate 'alter table bdps_branch_info drop partition p_' || tb.end_dt;
  end if;
  
    v_sql :='alter table bdps_branch_info add partition p_' || tb.end_dt || ' values(to_date(' || tb.end_dt || ',''yyyymmdd''))';
    
    execute immediate v_sql;

  
   -- 回插所有数据    
   
insert /*+ append */ into ${iol_schema}.bdps_branch_info(
            id -- ID
            ,brh_no -- 行号
            ,brh_name -- 行名
            ,brh_class -- 机构级别
            ,bln_up_brh_id -- 管辖机构
            ,tele_no -- 联系电话
            ,address -- 地址
            ,postno -- 邮编
            ,status -- 状态
            ,effect_date -- 生效日期
            ,expire_date -- 失效日期
            ,bln_brh_no -- 分行号
            ,ubank_no -- 联行号
            ,acct_brh_id -- 记账机构ID
            ,bop_financ_org_code -- 人民银行金融机构编号
            ,last_upd_oper_id -- 最后修改操作员号
            ,last_upd_time -- 最后修改时间
            ,dualcontrol_lockstatuscert -- 双岗复核锁标记
            ,dualcontrol_lockstatus -- 
            ,brcode -- 支行号
            ,manager -- 负责人
            ,misc -- 备注
            ,brh_full_name -- 机构全称
            ,belong_brh_id_opt -- 撤并机构id
            ,organcodekey -- 机构唯一标识
            ,funorgan -- 职能机构
            ,fundep -- 职能部门
            ,financialcode -- 金融机构标识码
            ,swiftcode -- SWIFT号码
            ,bankcode -- 支付系统银行行号
            ,businesslicense -- 营业执照号码
            ,organizationcode -- 内部机构代码
            ,taxid -- 税务登记证号
            ,organenfullname -- 内部机构英文全称
            ,organenshortname -- 内部机构英文简称
            ,organstatecode -- 机构营业状态代码
            ,organtype -- 内部机构类型代码
            ,isst -- 实体机构标志
            ,ishs -- 核算机构标志
            ,isyy -- 营业机构标志
            ,isxz -- 行政机构标志
            ,iszw -- 账务机构标志
            ,leafnoteflag -- 叶节点标志
            ,zwuporgancode -- 账务上级内部机构编码
            ,hsuporgancode -- 核算上级内部机构编码
            ,seque -- 机构顺序号
            ,country -- 所在国家
            ,province -- 所在省/州
            ,city -- 所在城市
            ,county -- 所在县/区
            ,email -- 电子邮箱
            ,url -- 网址
            ,countrycode -- 国际长途区号
            ,areacode -- 国内长途区号
            ,subphone -- 分机号
            ,servicephone -- 服务电话
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
            id -- ID
            ,brh_no -- 行号
            ,brh_name -- 行名
            ,brh_class -- 机构级别
            ,to_char(bln_up_brh_id) -- 管辖机构
            ,tele_no -- 联系电话
            ,address -- 地址
            ,postno -- 邮编
            ,status -- 状态
            ,effect_date -- 生效日期
            ,expire_date -- 失效日期
            ,bln_brh_no -- 分行号
            ,ubank_no -- 联行号
            ,acct_brh_id -- 记账机构ID
            ,bop_financ_org_code -- 人民银行金融机构编号
            ,last_upd_oper_id -- 最后修改操作员号
            ,last_upd_time -- 最后修改时间
            ,dualcontrol_lockstatuscert -- 双岗复核锁标记
            ,dualcontrol_lockstatus -- 
            ,brcode -- 支行号
            ,manager -- 负责人
            ,misc -- 备注
            ,brh_full_name -- 机构全称
            ,belong_brh_id_opt -- 撤并机构id
            ,organcodekey -- 机构唯一标识
            ,funorgan -- 职能机构
            ,fundep -- 职能部门
            ,financialcode -- 金融机构标识码
            ,swiftcode -- SWIFT号码
            ,bankcode -- 支付系统银行行号
            ,businesslicense -- 营业执照号码
            ,organizationcode -- 内部机构代码
            ,taxid -- 税务登记证号
            ,organenfullname -- 内部机构英文全称
            ,organenshortname -- 内部机构英文简称
            ,organstatecode -- 机构营业状态代码
            ,organtype -- 内部机构类型代码
            ,isst -- 实体机构标志
            ,ishs -- 核算机构标志
            ,isyy -- 营业机构标志
            ,isxz -- 行政机构标志
            ,iszw -- 账务机构标志
            ,leafnoteflag -- 叶节点标志
            ,zwuporgancode -- 账务上级内部机构编码
            ,hsuporgancode -- 核算上级内部机构编码
            ,seque -- 机构顺序号
            ,country -- 所在国家
            ,province -- 所在省/州
            ,city -- 所在城市
            ,county -- 所在县/区
            ,email -- 电子邮箱
            ,url -- 网址
            ,countrycode -- 国际长途区号
            ,areacode -- 国内长途区号
            ,subphone -- 分机号
            ,servicephone -- 服务电话
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
from ${iol_schema}.bdps_branch_info_bak${batch_date}
where end_dt = to_date(tb.end_dt,'yyyymmdd');
commit;

end loop;
end;
/
