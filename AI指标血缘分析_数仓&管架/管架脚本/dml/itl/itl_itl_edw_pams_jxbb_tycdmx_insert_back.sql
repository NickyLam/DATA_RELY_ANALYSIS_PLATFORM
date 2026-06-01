/*
Purpose:    技术缓冲层脚本，把数据文件加载到目标表的当天分区中。此脚本由生成引擎自动生成。
Author:     Sunline                                                              
Usage:      python $ETL_HOME/script/main.py yyyymmdd itl_itl_edw_pams_jxbb_tycdmx_insert_back
CreateDate: 20180515                                                             
FileType:   DML                                                                  
Logs:                                                                            
    zjj 2018-05-15 新建表本                                                      
*/
BEGIN
  FOR tjrq_rec IN (SELECT DISTINCT tjrq FROM ${itl_schema}.itl_edw_pams_jxbb_tycdmx_recal WHERE tjrq IS NOT NULL and etl_dt = to_date('${batch_date}','yyyyMMdd')) LOOP
    -- 删除分区（忽略错误）
    BEGIN
      EXECUTE IMMEDIATE 'ALTER TABLE ${itl_schema}.itl_edw_pams_jxbb_tycdmx DROP PARTITION p_' || tjrq_rec.tjrq;
    EXCEPTION WHEN OTHERS THEN NULL;
    END;

    -- 创建新分区
    EXECUTE IMMEDIATE 'ALTER TABLE ${itl_schema}.itl_edw_pams_jxbb_tycdmx ADD PARTITION p_' || tjrq_rec.tjrq || ' VALUES (TO_DATE(''' || tjrq_rec.tjrq || ''', ''YYYYMMDD''))';

    -- 插入数据
    EXECUTE IMMEDIATE 'INSERT INTO ${itl_schema}.itl_edw_pams_jxbb_tycdmx PARTITION (p_' || tjrq_rec.tjrq || ') 
    (etl_dt, 
     tjrq, 
     jxdxdh, 
     khdxdh, 
     jgkhdxdh, 
     jgdh, 
     jgmc, 
     hydh, 
     hymc, 
     ywbh, 
     cddm, 
     cdjc, 
     ssjgkhdxdh, 
     ssjgdh, 
     ssjgmc, 
     fxrq, 
     qxrq, 
     dqrq, 
     dfrq, 
     qx, 
     jxts, 
     fxjg, 
     nll, 
     fxl, 
     fxje, 
     bqye, 
     sjtzrkhh, 
     sjtzrqc, 
     fxjgmc, 
     xsjgmc, 
     nrj, 
     yrj, 
     nzc, 
     yzc, 
     ftpll, 
     dyftpjsr, 
     ljftpjsr, 
     fpbl, 
     fpjs, 
     ftplxsrylj, 
     ftplxsrnlj, 
     rzc, 
     drftpjsr, 
     dnftpjsr, 
     ftplxsr, 
     xsjgmczh, 
     xsjgmczb, 
     gsjgmczh, 
     gsjgmczb, 
     cpdm, 
     fptx, 
     txfpbl) 
    SELECT 
    to_date(tjrq,''yyyymmdd''), 
     tjrq, 
     jxdxdh, 
     khdxdh, 
     jgkhdxdh, 
     jgdh, 
     jgmc, 
     hydh, 
     hymc, 
     ywbh, 
     cddm, 
     cdjc, 
     ssjgkhdxdh, 
     ssjgdh, 
     ssjgmc, 
     fxrq, 
     qxrq, 
     dqrq, 
     dfrq, 
     qx, 
     jxts, 
     fxjg, 
     nll, 
     fxl, 
     fxje, 
     bqye, 
     sjtzrkhh, 
     sjtzrqc, 
     fxjgmc, 
     xsjgmc, 
     nrj, 
     yrj, 
     nzc, 
     yzc, 
     ftpll, 
     dyftpjsr, 
     ljftpjsr, 
     fpbl, 
     fpjs, 
     ftplxsrylj, 
     ftplxsrnlj, 
     rzc, 
     drftpjsr, 
     dnftpjsr, 
     ftplxsr, 
     xsjgmczh, 
     xsjgmczb, 
     gsjgmczh, 
     gsjgmczb, 
     cpdm, 
     fptx, 
     txfpbl
    FROM ${itl_schema}.itl_edw_pams_jxbb_tycdmx_recal PARTITION (p_${batch_date} ) WHERE tjrq = ''' || tjrq_rec.tjrq || '''';

  END LOOP;
  COMMIT;
END;
/