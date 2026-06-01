/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_uuss_uus_organ
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
                       FROM uuss_uus_organ_bak_${batch_date})
              WHERE RN = 1
 ) loop

  select count(partition_name) into v_var 
    from user_tab_partitions 
   where substr(partition_name,3) = tb.end_dt 
     and table_name = upper('uuss_uus_organ');
  
  if v_var <> 0 then 
    execute immediate 'alter table uuss_uus_organ drop partition p_' || tb.end_dt;
  end if;
  
    v_sql :='alter table uuss_uus_organ add partition p_' || tb.end_dt || ' values(to_date(' || tb.end_dt || ',''yyyymmdd''))';
    
    execute immediate v_sql;

  
   -- 回插所有数据    
   
insert /*+ append */ into ${iol_schema}.uuss_uus_organ(
            organcodekey -- 统一组织机构编码
            ,organcode -- 组织机构编号
            ,zoneno -- 分行号
            ,pbocfinancialcode -- 人民银行金融机构编号
            ,financialcode -- 金融机构标识码
            ,swiftcode -- SWIFT号码
            ,bankcode -- 支付系统银行行号
            ,legal -- 法人号
            ,businesslicense -- 营业执照号码
            ,organizationcode -- 组织机构代码
            ,taxid -- 税务登记证号
            ,organcnfullname -- 组织机构名称
            ,organcnshortname -- 组织机构简称
            ,organenfullname -- 组织机构英文全称
            ,organenshortname -- 组织机构英文简称
            ,organstatecode -- 机构营业状态
            ,organstatus -- 机构状态
            ,organfoundingdate -- 机构成立日期
            ,organclosedate -- 机构关闭日期
            ,organtype -- 组织机构类型
            ,isst -- 是否为实体机构
            ,ishs -- 是否为核算机构
            ,isyy -- 是否为营业机构
            ,isxz -- 是否为行政机构
            ,iszw -- 是否为账务机构
            ,organlevel -- 组织机构级别代码
            ,leafnoteflag -- 叶节点标志
            ,xzuporgancode -- 行政上级组织机构编码
            ,zwuporgancode -- 账务上级组织机构编码
            ,hsuporgancode -- 核算上级组织机构编码
            ,seque -- 机构顺序号
            ,postcode -- 邮政编码
            ,country -- 所在国家
            ,province -- 所在省/州
            ,city -- 所在城市
            ,county -- 所在县/区
            ,address -- 详细地址
            ,email -- 电子邮箱
            ,url -- 网址
            ,countrycode -- 国际长途区号
            ,areacode -- 国内长途区号
            ,phone -- 电话号码
            ,subphone -- 分机号
            ,servicephone -- 服务电话
            ,funorgan -- 职能机构
            ,fundep -- 职能部门
            ,orderno -- 显示顺序号
            ,financiallicnum -- 金融许可证号码
            ,organsystem -- 机构关联系统
            ,cbrcfininsttid -- 银监会金融机构编号
            ,unionfinancialcode -- 银联金融机构编号
            ,workstarttm -- 工作开始时间
            ,workendtm -- 工作结束时间
            ,updatedate -- 更新日期
            ,heademplyid -- 负责人员工编号
            ,isxnhs -- 是否为虚拟核算机构
            ,rhregcode -- 人行地区码
            ,blng_city_pbc -- 所属城市(人行)
            ,bankcodeperson -- 支付系统银行行号（用于个人结算账户报送）
            ,note1 -- 备用1
            ,note2 -- 备用2
            ,note3 -- 备用3
            ,note4 -- 备用4
            ,note5 -- 备用5
            ,note6 -- 备用6
            ,note7 -- 备用7
            ,note8 -- 备用8
            ,note9 -- 备用9
            ,note10 -- 备用10
            ,bbuporgancode -- 报表上级机构编号
            ,countyflag -- 县域机构标识
            ,technologyflag -- 科技支行标识
            ,specialflag -- 科技特色支行标识
            ,financeflag -- 科技金融专营机构标识
            ,freetradeflag -- 自贸区网点标识
            ,busitimedesc -- 网点营业时间说明
            ,busiscopdesc -- 主要业务范围说明
            ,physicsflag -- 零售管户机构|1是 0否
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
            organcodekey -- 统一组织机构编码
            ,organcode -- 组织机构编号
            ,zoneno -- 分行号
            ,pbocfinancialcode -- 人民银行金融机构编号
            ,financialcode -- 金融机构标识码
            ,swiftcode -- SWIFT号码
            ,bankcode -- 支付系统银行行号
            ,legal -- 法人号
            ,businesslicense -- 营业执照号码
            ,organizationcode -- 组织机构代码
            ,taxid -- 税务登记证号
            ,organcnfullname -- 组织机构名称
            ,organcnshortname -- 组织机构简称
            ,organenfullname -- 组织机构英文全称
            ,organenshortname -- 组织机构英文简称
            ,organstatecode -- 机构营业状态
            ,organstatus -- 机构状态
            ,organfoundingdate -- 机构成立日期
            ,organclosedate -- 机构关闭日期
            ,organtype -- 组织机构类型
            ,isst -- 是否为实体机构
            ,ishs -- 是否为核算机构
            ,isyy -- 是否为营业机构
            ,isxz -- 是否为行政机构
            ,iszw -- 是否为账务机构
            ,organlevel -- 组织机构级别代码
            ,leafnoteflag -- 叶节点标志
            ,xzuporgancode -- 行政上级组织机构编码
            ,zwuporgancode -- 账务上级组织机构编码
            ,hsuporgancode -- 核算上级组织机构编码
            ,seque -- 机构顺序号
            ,postcode -- 邮政编码
            ,country -- 所在国家
            ,province -- 所在省/州
            ,city -- 所在城市
            ,county -- 所在县/区
            ,address -- 详细地址
            ,email -- 电子邮箱
            ,url -- 网址
            ,countrycode -- 国际长途区号
            ,areacode -- 国内长途区号
            ,phone -- 电话号码
            ,subphone -- 分机号
            ,servicephone -- 服务电话
            ,funorgan -- 职能机构
            ,fundep -- 职能部门
            ,orderno -- 显示顺序号
            ,financiallicnum -- 金融许可证号码
            ,organsystem -- 机构关联系统
            ,cbrcfininsttid -- 银监会金融机构编号
            ,unionfinancialcode -- 银联金融机构编号
            ,workstarttm -- 工作开始时间
            ,workendtm -- 工作结束时间
            ,updatedate -- 更新日期
            ,heademplyid -- 负责人员工编号
            ,isxnhs -- 是否为虚拟核算机构
            ,rhregcode -- 人行地区码
            ,blng_city_pbc -- 所属城市(人行)
            ,bankcodeperson -- 支付系统银行行号（用于个人结算账户报送）
            ,note1 -- 备用1
            ,note2 -- 备用2
            ,note3 -- 备用3
            ,note4 -- 备用4
            ,note5 -- 备用5
            ,note6 -- 备用6
            ,note7 -- 备用7
            ,note8 -- 备用8
            ,note9 -- 备用9
            ,note10 -- 备用10
            ,bbuporgancode -- 报表上级机构编号
            ,countyflag -- 县域机构标识
            ,technologyflag -- 科技支行标识
            ,specialflag -- 科技特色支行标识
            ,financeflag -- 科技金融专营机构标识
            ,freetradeflag -- 自贸区网点标识
            ,busitimedesc -- 网点营业时间说明
            ,busiscopdesc -- 主要业务范围说明
            ,' ' as physicsflag -- 零售管户机构|1是 0否
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
from ${iol_schema}.uuss_uus_organ_bak_${batch_date}
where end_dt = to_date(tb.end_dt,'yyyymmdd');
commit;

end loop;
end;
/
