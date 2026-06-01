/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_icms_afterloan_write_off
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
                       FROM icms_afterloan_write_off_bak${batch_date})
              WHERE RN = 1
 ) loop

  select count(partition_name) into v_var 
    from user_tab_partitions 
   where substr(partition_name,3) = tb.end_dt 
     and table_name = upper('icms_afterloan_write_off');
  
  if v_var <> 0 then 
    execute immediate 'alter table icms_afterloan_write_off drop partition p_' || tb.end_dt;
  end if;
  
    v_sql :='alter table icms_afterloan_write_off add partition p_' || tb.end_dt || ' values(to_date(' || tb.end_dt || ',''yyyymmdd''))';
    
    execute immediate v_sql;

  
   -- 回插所有数据    
   
insert /*+ append */ into ${iol_schema}.icms_afterloan_write_off(
            serialno -- 业务流水号
            ,cancelrecein -- 核销表内利息
            ,claimsrecoverygrt -- 保证人、抵押/质押物追偿情况及结果
            ,claimsrecoveryborrower -- 借款人（或股权）追偿情况及结果
            ,customerid -- 客户号
            ,cussex -- 性别
            ,borrowercriminalnumber -- 借款人被判触犯刑律文号
            ,courtfinarulingtime -- 法院最终裁定时间
            ,dzhxbatchno -- 呆账核销批次号
            ,batsubtype -- 业务子类
            ,loanbalance -- 贷款余额
            ,amt -- 本金
            ,customername -- 客户名称
            ,borrowercriminaltime -- 借款人被判触犯刑律时间
            ,otherprooftime -- 其他形式证明时间
            ,approveverificationperiod -- 审批核销日期
            ,courtfinarulingtitle -- 法院最终裁定文件名
            ,inputuserid -- 登记人
            ,cancelcurtype -- 核销金额币种
            ,baddebtscausereason -- 呆账形成原因
            ,inputdate -- 登记日期
            ,certid -- 证件号码
            ,canceltype -- 核销类别
            ,responsibilityidentifyresult -- 责任认定及责任认定处理结果
            ,curtype -- 币种
            ,approvehxininterest -- 审批核销表内利息
            ,inputorgid -- 登记机构
            ,courtfinarulingnumber -- 法院最终裁定文号
            ,cancelamount -- 核销本金
            ,otherprooftitle -- 其他形式证明文件名
            ,approvedate -- 核销日期
            ,finabrid -- 账务机构
            ,certtype -- 证件类型
            ,approveamt -- 核销金额
            ,approvehxoutinterest -- 审批核销表外利息
            ,accids -- 借据编号集合
            ,cusmarst -- 婚姻状况
            ,approvestatus -- 审批状态
            ,borrowerbusicodecanceltime -- 工商部门注销（或吊销）借款人营业执照时间
            ,uplproductid -- 微贷业务品种
            ,compname -- 经营企业名称
            ,isretainrecourse -- 是否保留对债务人的追索权
            ,cancelreceout -- 核销表外利息
            ,borrowercriminaltitle -- 借款人被判触犯刑律文件名
            ,advancepayment -- 垫付费用
            ,otherproofnumber -- 其他形式证明文号
            ,industry -- 所属行业
            ,migtflag -- 迁移标志：crs rcr ilc upl
            ,exposureamount -- 敞口金额
            ,advancepatotal -- 总垫付金额
            ,completeflag -- 数据录入完整性标识
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
            serialno -- 业务流水号
            ,cancelrecein -- 核销表内利息
            ,claimsrecoverygrt -- 保证人、抵押/质押物追偿情况及结果
            ,claimsrecoveryborrower -- 借款人（或股权）追偿情况及结果
            ,customerid -- 客户号
            ,cussex -- 性别
            ,borrowercriminalnumber -- 借款人被判触犯刑律文号
            ,courtfinarulingtime -- 法院最终裁定时间
            ,dzhxbatchno -- 呆账核销批次号
            ,batsubtype -- 业务子类
            ,loanbalance -- 贷款余额
            ,amt -- 本金
            ,customername -- 客户名称
            ,borrowercriminaltime -- 借款人被判触犯刑律时间
            ,otherprooftime -- 其他形式证明时间
            ,approveverificationperiod -- 审批核销日期
            ,courtfinarulingtitle -- 法院最终裁定文件名
            ,inputuserid -- 登记人
            ,cancelcurtype -- 核销金额币种
            ,baddebtscausereason -- 呆账形成原因
            ,inputdate -- 登记日期
            ,certid -- 证件号码
            ,canceltype -- 核销类别
            ,responsibilityidentifyresult -- 责任认定及责任认定处理结果
            ,curtype -- 币种
            ,approvehxininterest -- 审批核销表内利息
            ,inputorgid -- 登记机构
            ,courtfinarulingnumber -- 法院最终裁定文号
            ,cancelamount -- 核销本金
            ,otherprooftitle -- 其他形式证明文件名
            ,approvedate -- 核销日期
            ,finabrid -- 账务机构
            ,certtype -- 证件类型
            ,approveamt -- 核销金额
            ,approvehxoutinterest -- 审批核销表外利息
            ,accids -- 借据编号集合
            ,cusmarst -- 婚姻状况
            ,approvestatus -- 审批状态
            ,borrowerbusicodecanceltime -- 工商部门注销（或吊销）借款人营业执照时间
            ,uplproductid -- 微贷业务品种
            ,compname -- 经营企业名称
            ,isretainrecourse -- 是否保留对债务人的追索权
            ,cancelreceout -- 核销表外利息
            ,borrowercriminaltitle -- 借款人被判触犯刑律文件名
            ,advancepayment -- 垫付费用
            ,otherproofnumber -- 其他形式证明文号
            ,industry -- 所属行业
            ,migtflag -- 迁移标志：crs rcr ilc upl
            ,exposureamount -- 敞口金额
            ,advancepatotal -- 总垫付金额
            ,completeflag -- 数据录入完整性标识
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
from ${iol_schema}.icms_afterloan_write_off_bak${batch_date}
where end_dt = to_date(tb.end_dt,'yyyymmdd');
commit;

end loop;
end;
/
