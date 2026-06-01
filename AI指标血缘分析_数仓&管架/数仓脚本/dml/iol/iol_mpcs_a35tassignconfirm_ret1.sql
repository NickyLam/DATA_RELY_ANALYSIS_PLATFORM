/*
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_mpcs_a35tassignconfirm_ret1
CreateDate: 20250206
*/

set timing on
-- 1.1 alter parallel
alter session force parallel query parallel 8;
alter session force parallel dml parallel 8;

declare
  v_flag   number(10) :=0;

begin
  for tb in (select partition_name,table_name,substr(partition_name,3) as etl_dt
               from user_tab_partitions
                   where table_name = upper('mpcs_a35tassignconfirm_bak${batch_date}')
                       and partition_name <> 'P_19000101'
             ) loop

  select count(*) into v_flag
    from all_tab_partitions
   where table_owner = upper('iol')
     and table_name = upper('mpcs_a35tassignconfirm')
     and partition_name = tb.partition_name;

  if v_flag <> 0 then
    execute immediate 'alter table mpcs_a35tassignconfirm drop partition '|| tb.partition_name ;
  end if;

    execute immediate 'alter table mpcs_a35tassignconfirm add partition ' || tb.partition_name || ' values (to_date(' || tb.etl_dt || ',''yyyymmdd''))';


-- 回插所有数据

insert /*+ append */ into ${iol_schema}.mpcs_a35tassignconfirm (
    cobank -- 合作银行 (0-平安  1-交行)
    ,custname -- 客户名称
    ,idtype -- 证件类型
    ,idno -- 证件号码
    ,acctno -- 结算账号
    ,pswd -- 结算账号密码
    ,seccd -- 券商代码
    ,secname -- 券商名称
    ,capitalacctno -- 证券资金台账号
    ,capitalpswd -- 券商证券资金密码
    ,ccy -- 币种
    ,custmanagerid -- 客户经理号
    ,custtype -- 客户类型 (00：机构 01：个人 默认“个人”)
    ,openbrcno -- 开户机构 (4位的合作行机构编号)
    ,sex -- 性别(0-男 1-女)
    ,secbrcno -- 券商营业部编号
    ,tycustno -- 同业客户号
    ,tyacctno -- 同业结算账号
    ,signtm -- 预指定确定时间 (统计月开户数)
    ,brcno -- 机构号
    ,brcname -- 机构名称
    ,confirmstatus -- 签约状态
    ,rspmsg -- 签约响应信息
    ,bizagtname -- 经办人姓名
    ,bizagtidtype -- 经办人证件类型
    ,bizagtidno -- 经办人证件号码
    ,custno -- 客户号
    ,reserve2 -- 备用字段2
    ,reserve3 -- 备用字段3
    ,issign -- 是否签署(0-否，1-是)
    ,treaty_version -- 签约协议书的版本号
    ,argue_dealway -- 争议选择解决方式(01-深圳国际仲裁院,02-平安所在人民法院)
    ,treaty_source -- 签约协议来源(00-待签署,02-手机银行,03-个人网银,04-柜面,05-其他)
    ,signdate -- 签署协议时间
    ,signseqno -- 签署流水号
    ,sign_source -- 三方存管签约来源(0-未知，1-柜面，2-其他第三方)
    ,sign_ip -- 签署IP
    ,sign_mac -- 签署MAC地址
    ,sign_type -- 电脑或手机型号
    ,reserve4 -- 备用字段4
    ,etl_dt -- ETL处理日期
    ,etl_timestamp -- ETL处理时间戳
)
select
    cobank as cobank -- 合作银行 (0-平安  1-交行)
    ,custname as custname -- 客户名称
    ,idtype as idtype -- 证件类型
    ,idno as idno -- 证件号码
    ,acctno as acctno -- 结算账号
    ,pswd as pswd -- 结算账号密码
    ,seccd as seccd -- 券商代码
    ,secname as secname -- 券商名称
    ,capitalacctno as capitalacctno -- 证券资金台账号
    ,capitalpswd as capitalpswd -- 券商证券资金密码
    ,ccy as ccy -- 币种
    ,custmanagerid as custmanagerid -- 客户经理号
    ,custtype as custtype -- 客户类型 (00：机构 01：个人 默认“个人”)
    ,openbrcno as openbrcno -- 开户机构 (4位的合作行机构编号)
    ,sex as sex -- 性别(0-男 1-女)
    ,secbrcno as secbrcno -- 券商营业部编号
    ,tycustno as tycustno -- 同业客户号
    ,tyacctno as tyacctno -- 同业结算账号
    ,signtm as signtm -- 预指定确定时间 (统计月开户数)
    ,brcno as brcno -- 机构号
    ,brcname as brcname -- 机构名称
    ,confirmstatus as confirmstatus -- 签约状态
    ,rspmsg as rspmsg -- 签约响应信息
    ,bizagtname as bizagtname -- 经办人姓名
    ,bizagtidtype as bizagtidtype -- 经办人证件类型
    ,bizagtidno as bizagtidno -- 经办人证件号码
    ,custno as custno -- 客户号
    ,reserve2 as reserve2 -- 备用字段2
    ,reserve3 as reserve3 -- 备用字段3
    ,' ' as issign -- 是否签署(0-否，1-是)
    ,' ' as treaty_version -- 签约协议书的版本号
    ,' ' as argue_dealway -- 争议选择解决方式(01-深圳国际仲裁院,02-平安所在人民法院)
    ,' ' as treaty_source -- 签约协议来源(00-待签署,02-手机银行,03-个人网银,04-柜面,05-其他)
    ,' ' as signdate -- 签署协议时间
    ,' ' as signseqno -- 签署流水号
    ,' ' as sign_source -- 三方存管签约来源(0-未知，1-柜面，2-其他第三方)
    ,' ' as sign_ip -- 签署IP
    ,' ' as sign_mac -- 签署MAC地址
    ,' ' as sign_type -- 电脑或手机型号
    ,' ' as reserve4 -- 备用字段4
    ,etl_dt as etl_dt -- ETL处理日期
    ,etl_timestamp as etl_timestamp -- ETL处理时间戳
from ${iol_schema}.mpcs_a35tassignconfirm_bak${batch_date}
where etl_dt = to_date(tb.etl_dt, 'yyyymmdd');

commit;

end loop;
end;
/

